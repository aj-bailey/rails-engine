class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end
end