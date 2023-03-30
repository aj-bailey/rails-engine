require 'rails_helper'

RSpec.describe 'Items Merchant API' do
  describe 'Items Merchant Index API' do
    it 'sends the merchant of an item' do
      merchant = create(:merchant)
      item = create(:item, merchant: merchant)

      get api_v1_item_merchant_index_path(item)

      expect(response).to be_successful

      item_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(item_merchant[:data]).to have_key(:id)
      expect(item_merchant[:data][:id]).to be_an(String)

      expect(item_merchant[:data][:attributes]).to have_key(:name)
      expect(item_merchant[:data][:attributes][:name]).to be_a(String)
    end

    it 'sends a 404 status error when item id not found' do
      get api_v1_item_merchant_index_path(1)

      expect(response.status).to eq(404)
      
      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:message]).to eq("your query could not be completed")
      expect(parsed_item[:errors]).to eq(["Couldn't find Item with 'id'=1"])
    end
  end
end
