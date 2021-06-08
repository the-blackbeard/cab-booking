class CabBookingServices::Update
  def initialize(context)
    @context = Hashie::Mash.new context
    @cab_booking = CabBooking.find(@context["id"].to_i)
    @current_status = @cab_booking.status

    @valid = nil
    @errors = []
  end

  def execute
    self.validate if @valid.nil?

    return @context if @valid

    ActiveRecord::Base.transaction do
      update_booking
      update_user_and_cab_lat_long unless @valid

      raise ActiveRecord::Rollback if @valid
    end

    @context
  end

  def validate
    errors = []

    errors << "Booking params not present to update" if @context["cab_booking"].blank?

    @context[:errors] = errors
    return @valid = errors.present?
  end

  private

  def update_booking
    @cab_booking.assign_attributes(@context["cab_booking"])
    assign_time

    if @cab_booking.save
      @context[:result] = @cab_booking
    else
      @context[:errors] = @cab_booking.errors.full_messages
      @valid = true
    end
  end

  def assign_time
    if @context["cab_booking"]["status"] == "completed"
      @cab_booking.end_time = Time.now
    end
  end

  def update_user_and_cab_lat_long
    if @current_status == "started" && @cab_booking.completed?
      update_lat_long_for_cab
      update_lat_long_for_user
    end
  end

  def update_lat_long_for_user
    result = UserServices::Update.new(user_update_params)
    response = result.execute

    if response.errors.present?
      @context[:errors] = response.errors
      @valid = true
    end
  end

  def update_lat_long_for_cab
    result = CabServices::Update.new(cab_update_params)
    response = result.execute

    if response.errors.present?
      @context[:errors] = response.errors
      @valid = true
    end
  end

  def cab_update_params()
    ActionController::Parameters.permit_all_parameters = true
    params = ActionController::Parameters.new(
      id: @cab_booking.cab_id,
      cab: {
        lat: @cab_booking.ending_lat,
        long: @cab_booking.ending_long
      }
    )

    params
  end

  def user_update_params()
    ActionController::Parameters.permit_all_parameters = true
    params = ActionController::Parameters.new(
      id: @cab_booking.user_id,
      user: {
        lat: @cab_booking.ending_lat,
        long: @cab_booking.ending_long
      }
    )

    params
  end
end
