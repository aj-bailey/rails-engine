require "rails_helper"

RSpec.describe "Merchant API" do
  describe "Merchant Index API" do
    it "sends a list of merchants" do
      create_list(:merchant, 10)

      get api_v1_merchants_path

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(10)

      merchants[:data].each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(String)

        expect(merchant[:attributes]).to have_key(:name)
        expect(merchant[:attributes][:name]).to be_a(String)
      end
    end
  end

  describe "Merchant Show API" do
    it "sends a single merchant by its id" do
      merchant = create(:merchant)

      get api_v1_merchant_path(merchant)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_merchant[:data][:id]).to eq(merchant.id.to_s)
      expect(parsed_merchant[:data][:id]).to be_an(String)

      expect(parsed_merchant[:data][:attributes][:name]).to eq(merchant.name)
      expect(parsed_merchant[:data][:attributes][:name]).to be_a(String)
    end

    it "sends a 404 status error when merchant id not found" do
      get api_v1_merchant_path(1)

      expect(response.status).to eq(404)

      parsed_merchant = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_merchant[:message]).to eq("your query could not be completed")
      expect(parsed_merchant[:errors]).to eq(["Couldn't find Merchant with 'id'=1"])
    end
  end
end
