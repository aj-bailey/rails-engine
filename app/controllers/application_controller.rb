class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_400
  rescue_from ActionController::ParameterMissing, with: :render_400

  def render_404
    if object_type.include?("item")
      render json: ItemSerializer.new(Item.new), status: 404
    else
      render json: MerchantSerializer.new(Merchant.new), status: 404
    end
  end

  def render_400
    render plain: "400 Bad Request", status: 400
  end

  def object_type
    object_index = params[:controller].rindex("/") + 1
    params[:controller][object_index..-1]
  end
end
