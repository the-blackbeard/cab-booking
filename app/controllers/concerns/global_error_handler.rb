module GlobalErrorHandler extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :render_custom_exception_response
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  end

  def render_not_found_response(exception)
    Rails.logger.error(exception)
    render json: { error: exception.message, errors: [exception.message], }, status: :not_found
  end

  def render_custom_exception_response(exception)
    Rails.logger.error(exception)

    render json: { error: "Oops! Something went wrong", errors: ["Oops! Something went wrong"] }, status: :internal_server_error
  end
end
