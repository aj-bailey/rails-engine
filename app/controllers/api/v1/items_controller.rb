class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def destroy
    Item.destroy(params[:id])

    render status: 204
  end

  def update
    item = Item.find(params[:id])

    item.update!(item_params)

    render json: ItemSerializer.new(item)
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
