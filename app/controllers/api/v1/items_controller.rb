class Api::V1::ItemsController < Api::ApiController
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
    item = Item.find(params[:id])

    destroy_associated_single_item_invoices

    Item.destroy(item.id)

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

  def destroy_associated_single_item_invoices
    item_invoices = Item.find(params[:id]).invoices

    item_invoices.single_item_invoices.each do |single_item_invoice|
      Invoice.destroy(single_item_invoice.id)
    end
  end
end
