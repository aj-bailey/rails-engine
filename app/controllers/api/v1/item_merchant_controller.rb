class Api::V1::ItemMerchantController < ApplicationController
  def index
    item = Item.find(params[:item_id])
    render json: MerchantSerializer.new(Merchant.find(item.merchant_id))
  end
end
