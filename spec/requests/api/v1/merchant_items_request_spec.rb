require 'rails_helper'

RSpec.describe 'Merchant Items API' do
  describe 'Merchant Items Index API' do
    it 'sends a list of merchant items' do
      merchant = create(:merchant)
      create_list(:item, 4, merchant: merchant)

      get api_v1_merchant_items_path(merchant)

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)
      
      merchant_items[:data].each do |merchant_item|
        expect(merchant_item).to have_key(:id)
        expect(merchant_item[:id]).to be_an(String)

        expect(merchant_item[:attributes]).to have_key(:name)
        expect(merchant_item[:attributes][:name]).to be_an(String)

        expect(merchant_item[:attributes]).to have_key(:description)
        expect(merchant_item[:attributes][:description]).to be_an(String)

        expect(merchant_item[:attributes]).to have_key(:unit_price)
        expect(merchant_item[:attributes][:unit_price]).to be_an(Float)
      end
    end

    it 'sends a 404 status error when merchant id not found' do
      get api_v1_merchant_items_path(1)

      expect(response.status).to eq(404)
      
      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:data][:id]).to eq(nil)
      expect(parsed_item[:data][:type]).to eq("item")
      expect(parsed_item[:data][:attributes][:name]).to eq(nil)
      expect(parsed_item[:data][:attributes][:description]).to eq(nil)
      expect(parsed_item[:data][:attributes][:unit_price]).to eq(nil)
      expect(parsed_item[:data][:attributes][:merchant_id]).to eq(nil)
    end
  end
end
