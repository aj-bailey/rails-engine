class Api::ApiController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :error_response
  rescue_from ActiveRecord::RecordInvalid, with: :error_response
  rescue_from ActionController::ParameterMissing, with: :error_response

  def error_response(exception)
    render json: ErrorSerializer.new(exception).serialized_json, status: error_status(exception)
  end

  def error_status(exception)
    return 404 if exception.class == ActiveRecord::RecordNotFound
    400
  end
end