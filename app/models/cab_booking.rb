class CabBooking < ApplicationRecord
  belongs_to :cab
  belongs_to :user

  enum status: [:started, :completed, :cancelled]

  validates_presence_of :starting_lat, :starting_long, :status, :user_id, :cab_id
  validate :end_time_after_start_time
  validate :user_should_be_rider
  validate :no_booking_when_scheduled, on: :create
  validate :end_lat_long_required_on_complete, if: Proc.new{ |cab_booking| cab_booking.status_changed? }

  #Scopes
  scope :scheduled_started_cabs, -> {
    where(status: [CabBooking.statuses[:scheduled], CabBooking.statuses[:started]])
  }

  scope :filter,->(options = {}){
    query = all
    query = query.where(user_id: options[:user_id].to_i) if options[:user_id].present?
    query = query.where(cab_id: options[:cab_id].to_i) if options[:cab_id].present?
    query = query.where("start_time >= ?", options[:ride_started_at]) if options[:ride_started_at].present?
    query = query.where("end_time <= ?", options[:ride_started_at]) if options[:ride_started_at].present?

    query
  }

  def end_lat_long_required_on_complete
    if self.status_was == "started" && self.completed? && (self.ending_lat.nil? || self.ending_long.nil?)
      errors.add(:base, "Trip can not be completed")
    end
  end

  def end_time_after_start_time
    if (start_time.present? && end_time.present?) && (end_time < start_time)
      errors.add :end_time, 'must be after start time'
    end
  end

  def user_should_be_rider
    if user_id.present?
      errors.add :user, 'should be rider' if user.driver?
    end
  end

  def no_booking_when_scheduled
    if user.present? && user.cab_bookings.scheduled_started_cabs.count > 0
      errors.add :user, "can not book another cab as a ride is #{status} for user."
    end
  end
end
