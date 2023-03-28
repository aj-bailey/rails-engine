require 'rails_helper'

RSpec.describe 'Items API' do
  describe 'Items Index API' do
    it 'sends a list of items' do
      create_list(:item, 5)

      get api_v1_items_path

      expect(response).to be_successful

      items = JSON.parse(response.body, symbolize_names: true)

      items[:data].each do |item|
        expect(item).to have_key(:id)
        expect(item[:id]).to be_an(String)

        expect(item[:attributes]).to have_key(:name)
        expect(item[:attributes][:name]).to be_a(String)

        expect(item[:attributes]).to have_key(:description)
        expect(item[:attributes][:description]).to be_a(String)

        expect(item[:attributes]).to have_key(:unit_price)
        expect(item[:attributes][:unit_price]).to be_a(Float)

        expect(item[:attributes]).to have_key(:merchant_id)
        expect(item[:attributes][:merchant_id]).to be_an(Integer)
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

      expect(parsed_item[:data][:id]).to eq(item.id.to_s)
      expect(parsed_item[:data][:id]).to be_an(String)

      expect(parsed_item[:data][:attributes][:name]).to eq(item.name)
      expect(parsed_item[:data][:attributes][:name]).to be_a(String)

      expect(parsed_item[:data][:attributes][:description]).to eq(item.description)
      expect(parsed_item[:data][:attributes][:description]).to be_a(String)

      expect(parsed_item[:data][:attributes][:unit_price]).to eq(item.unit_price)
      expect(parsed_item[:data][:attributes][:unit_price]).to be_a(Float)

      expect(parsed_item[:data][:attributes][:merchant_id]).to eq(item.merchant_id)
      expect(parsed_item[:data][:attributes][:merchant_id]).to be_a(Integer)
    end

    it 'sends a 404 status error when item id not found' do
      get api_v1_item_path(1)

      expect(response.status).to eq(404)
      expect(response.body).to eq("404 Not Found")
    end
  end

  describe "Item Create API" do
    it "can create a new item" do
      merchant = create(:merchant)
      item_params = ({
                      name: "Item Name",
                      description: "Item Description",
                      unit_price: 3.99,
                      merchant_id: merchant.id
                    })

      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_items_path, headers: headers, params: JSON.generate({ item: item_params })
      created_item = Item.last
      
      expect(response).to be_successful
      expect(created_item.name).to eq(item_params[:name])
      expect(created_item.description).to eq(item_params[:description])
      expect(created_item.unit_price).to eq(item_params[:unit_price])
      expect(created_item.merchant_id).to eq(item_params[:merchant_id])
    end

    it "sends a 400 Bad Request status error when invalid parameters are submitted" do
      merchant = create(:merchant)
      item_params = ({
                      description: "Item Description",
                      unit_price: 3.99,
                      merchant_id: merchant.id
                    })

      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_items_path, headers: headers, params: JSON.generate({ item: item_params })

      expect(response.status).to eq(400)
      expect(response.body).to eq("400 Bad Request")
    end
  end
end