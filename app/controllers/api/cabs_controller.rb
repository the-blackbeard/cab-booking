class Api::CabsController < Api::ApiController
  def update
    result = CabServices::Update.new(update_params)
    response = result.execute

    if response.errors.present?
      render json: { errors: response.errors, error: response.errors.join(', ') }, status: :bad_request
    else
      render json: { user: response.result.as_json }, status: :ok
    end
  end

  private

  def update_params
    params.permit(
      :id,
      cab: [
        :registration_number,
        :plate_number,
        :status,
        :modelname,
        :lat,
        :long
      ]
    )
  end
end
