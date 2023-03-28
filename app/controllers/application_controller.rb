class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_400

  def render_404
    render plain: "404 Not Found", status: 404
  end

  def render_400
    render plain: "400 Bad Request", status: 400
  end
end
