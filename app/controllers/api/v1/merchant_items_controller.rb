class Api::V1::MerchantItemsController < Api::ApiController
  def index
    render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
  end
end
