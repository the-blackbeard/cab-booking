class CabBookingServices::Create
  def initialize(context)
    @context = Hashie::Mash.new context
    @params = @context

    @valid = nil
    @errors = []
  end

  def execute
    self.validate if @valid.nil?

    return @context if @valid

    cab = get_nearest_cab
    schedule_booking(cab) unless @valid

    @context
  end

  def validate
    errors = []

    errors << "Booking params is not present" if @context["cab_booking"].blank?

    @context[:errors] = errors
    return @valid = errors.present?
  end

  private

  def get_nearest_cab
    starting_lat = @context["cab_booking"]["starting_lat"].to_f
    starting_long = @context["cab_booking"]["starting_long"].to_f

    nearest_cab = Cab.nearest(starting_lat, starting_long)
    if nearest_cab.present?
      return nearest_cab
    else
      @context[:errors] = ["No cabs available"]
      @valid = true
    end
  end

  def schedule_booking(cab)
    @cab_booking = CabBooking.new(@context["cab_booking"])
    @cab_booking.status = "started"
    @cab_booking.cab_id = cab.id
    @cab_booking.start_time = Time.now

    if @cab_booking.save
      @context[:result] = @cab_booking
    else
      @context[:errors] = @cab_booking.errors.full_messages
      @valid = true
    end
  end
end
