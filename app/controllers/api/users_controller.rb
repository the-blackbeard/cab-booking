class Api::UsersController < Api::ApiController
  def create
    result = UserServices::Create.new(create_params)
    response = result.execute

    if response.errors.present?
      render json: { errors: response.errors, error: response.errors.join(', ') }, status: :bad_request
    else
      render json: { user: response.result.as_json }, status: :ok
    end
  end

  private

  def create_params
    params.permit(
      user: [
        :first_name,
        :last_name,
        :email,
        :long,
        :lat,
        :role,
        :phone_number
      ],
      cab: [
        :registration_number,
        :plate_number,
        :status,
        :modelname,
        :lat,
        :long,
        :booking_range
      ]
    )
  end
end
