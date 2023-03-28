require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'Items Index API' do
    it 'sends a list of items' do
      create_list(:item, 5)

      get api_v1_items_path

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      items.each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(Integer)

        expect(item).to have_key(:name)
        expect(item[:name]).to be_a(String)

        expect(item).to have_key(:description)
        expect(item[:description]).to be_a(String)

        expect(item).to have_key(:unit_price)
        expect(item[:unit_price]).to be_a(Float)

        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(Integer)
      end
    end
  end

  describe "Item Show API" do
    it "sends an item with given :id" do
      item = create(:item)

      get api_v1_item_path(item)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:id]).to eq(item.id)
      expect(parsed_item[:id]).to be_an(Integer)

      expect(parsed_item[:name]).to eq(item.name)
      expect(parsed_item[:name]).to be_a(String)

      expect(parsed_item[:description]).to eq(item.description)
      expect(parsed_item[:description]).to be_a(String)

      expect(parsed_item[:unit_price]).to eq(item.unit_price)
      expect(parsed_item[:unit_price]).to be_a(Float)

      expect(parsed_item[:merchant_id]).to eq(item.merchant_id)
      expect(parsed_item[:merchant_id]).to be_a(Integer)
    end

    it 'sends a 404 status error when item id not found' do
      get api_v1_item_path(1)

      expect(response.status).to eq(404)
      expect(response.body).to eq("404 Not Found")
    end
  end
end