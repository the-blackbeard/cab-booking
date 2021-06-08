class Cab < ApplicationRecord
  belongs_to :user
  has_many :cab_bookings

  validates_presence_of :lat, :long, :status, :plate_number, :registration_number, :user_id
  validates_uniqueness_of :user_id
  validates_uniqueness_of :registration_number
  validates_uniqueness_of :plate_number

  enum status: [:available, :booked, :offline]

  #Scopes

  scope :available_cabs, -> { where(status: 'available').order(created_at: 'desc') }

  def self.nearest(lat, long)
    nearest_cab = nil
    shortest_distance = APP_CONFIG["min_distance_to_book"]
    self.available_cabs.each do |cab|
      distance = Math.sqrt((lat - cab.lat)**2 + (long - cab.long)**2)

      if distance <= shortest_distance
        shortest_distance = distance
        nearest_cab = cab
      end
    end

    nearest_cab
  end
end
