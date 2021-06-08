class Api::CabBookingsController < Api::ApiController
  def create
    result = CabBookingServices::Create.new(create_params)
    response = result.execute

    if response.errors.present?
      render json: { errors: response.errors, error: response.errors.join(', ') }, status: :bad_request
    else
      render json: { user: response.result.as_json }, status: :ok
    end
  end

  def update
    result = CabBookingServices::Update.new(update_params)
    response = result.execute

    if response.errors.present?
      render json: { errors: response.errors, error: response.errors.join(', ') }, status: :bad_request
    else
      render json: { user: response.result.as_json }, status: :ok
    end
  end

  def index
    @bookings = CabBooking.filter(filter_params)
    render json: @bookings.as_json
  end

  private

  def filter_params
    params.permit(
      :user_id,
      :cab_id,
      :ride_started_at,
      :ride_end_at
    )
  end

  def create_params
    params.permit(
      cab_booking: [
        :starting_lat,
        :starting_long,
        :ending_lat,
        :ending_long,
        :user_id
      ]
    )
  end

  def update_params
    params.permit(
      :id,
      cab_booking: [
        :starting_lat,
        :starting_long,
        :ending_lat,
        :ending_long,
        :status
      ]
    )
  end
end
