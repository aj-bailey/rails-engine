require "rails_helper"

RSpec.describe "Items API" do
  describe "Items Index API" do
    it "sends a list of items" do
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

    it "sends a 404 status error when item id not found" do
      get api_v1_item_path(1)

      expect(response.status).to eq(404)

      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:message]).to eq("your query could not be completed")
      expect(parsed_item[:errors]).to eq(["Couldn't find Item with 'id'=1"])
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

    it "sends a 400 Bad Request status error when at least one but not all parameters are missing" do
      merchant = create(:merchant)
      item_params = ({
                      unit_price: 3.99,
                      merchant_id: merchant.id
                    })

      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_items_path, headers: headers, params: JSON.generate({ item: item_params })

      expect(response.status).to eq(400)

      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:message]).to eq("Validation failed")
      expect(parsed_item[:errors]).to eq(["Name can't be blank", "Description can't be blank"])
    end

    it "sends a 400 Bad Request status error when at least one parameter is incorrect data type" do
      #not sure if this is correct way to test this - see unit_price
      merchant = create(:merchant)
      item_params = ({
                      name: "Item Name",
                      description: "Item Description",
                      unit_price: "three dollars",
                      merchant_id: merchant.id
                    })

      headers = { "CONTENT_TYPE" => "application/json" }

      post api_v1_items_path, headers: headers, params: JSON.generate({ item: item_params })

      expect(response.status).to eq(400)

      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:message]).to eq("Validation failed")
      expect(parsed_item[:errors]).to eq(["Unit price is not a number"])
    end

    it "sends a 400 Bad Request status error when no parameters are submitted" do
      post api_v1_items_path

      expect(response.status).to eq(400)
      
      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:message]).to eq("param is missing or the value is empty")
      expect(parsed_item[:errors]).to eq(["item"])
    end
  end

  describe "Item Destroy API" do
    it "can destroy an item" do
      item = create(:item)

      expect(Item.count).to eq(1)

      delete api_v1_item_path(item)

      expect(response).to be_successful
      expect(Item.count).to eq(0)
      expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "sends a 404 Not Found status when item id not found" do
      delete api_v1_item_path(1)

      expect(response.status).to eq(404)

      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:message]).to eq("your query could not be completed")
      expect(parsed_item[:errors]).to eq(["Couldn't find Item with 'id'=1"])
    end

    it "deletes associated invoices that only have this item on it" do
      merchant = create(:merchant)
      to_be_deleted_item = create(:item, merchant: merchant)
      item_2 = create(:item, merchant: merchant)

      to_be_deleted_invoice_1 = create(:invoice, merchant: merchant)
      to_be_deleted_invoice_2 = create(:invoice, merchant: merchant)
      to_be_deleted_invoice_3 = create(:invoice, merchant: merchant)

      invoice_4 = create(:invoice, merchant: merchant)

      create(:invoice_item, item: to_be_deleted_item, invoice: to_be_deleted_invoice_1)
      create(:invoice_item, item: to_be_deleted_item, invoice: to_be_deleted_invoice_2)
      create(:invoice_item, item: to_be_deleted_item, invoice: to_be_deleted_invoice_3)
      create(:invoice_item, item: to_be_deleted_item, invoice: invoice_4)
      create(:invoice_item, item: item_2, invoice: invoice_4)

      expect(Invoice.count).to eq(4)

      delete api_v1_item_path(to_be_deleted_item)

      expect(response).to be_successful
      expect(Invoice.count).to eq(1)
      expect(Invoice.first.id).to eq(invoice_4.id)
    end
  end

  describe "Item Update API" do
    it "can destroy an item" do
      item = create(:item, name: "original name")
      
      item_params = { name: "new name" }
      headers = { "CONTENT_TYPE" => "application/json" }

      patch api_v1_item_path(item), headers: headers, params: JSON.generate({ item: item_params })
      item = Item.find(item.id)

      expect(response).to be_successful
      expect(response.status).to be(200)
      expect(item.name).to_not eq("original name")
      expect(item.name).to eq("new name")
    end

    it "sends a 404 Not Found status when item id not found" do
      patch api_v1_item_path(1)

      expect(response.status).to eq(404)

      parsed_item = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_item[:message]).to eq("your query could not be completed")
      expect(parsed_item[:errors]).to eq(["Couldn't find Item with 'id'=1"])
    end
  end
end