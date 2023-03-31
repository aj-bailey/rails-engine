require "rails_helper"

RSpec.describe "Items Search API" do
  describe "Items Search Index API" do
    it "returns an array of json objects for all items matching case-insensitive name parameter" do
      turing_hat = create(:item, name: "Turing Hat")
      turing_shirt = create(:item, name: "Turing Shirt")
      gold_ring = create(:item, name: "Gold Ring")
      thing = create(:item, name: "Thing")

      get "/api/v1/items/find_all?name=ring"

      expect(response).to be_successful
      expect(response.status).to eq(200)

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

      expect(items[:data].count).to eq(3)
      expect(items[:data][0][:id]).to eq(gold_ring.id.to_s)
      expect(items[:data][1][:id]).to eq(turing_hat.id.to_s)
      expect(items[:data][2][:id]).to eq(turing_shirt.id.to_s)
    end

    it "returns an empty array of json objects when there are no matches for name parameters" do
      get "/api/v1/items/find_all?name=ring"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      items = JSON.parse(response.body, symbolize_names: true)

      expect(items[:data].count).to eq(0)
    end

    context "Pricing Parameters" do
      before(:each) do
        @turing_hat = create(:item, name: "Turing Hat", unit_price: 19.99)
        @turing_shirt = create(:item, name: "Turing Shirt", unit_price: 24.99)
        @gold_ring = create(:item, name: "Gold Ring", unit_price: 74.99)
        @thing = create(:item, name: "Thing", unit_price: 10_000.99)
      end

      it "returns an array of all items greater than min price parameter given" do
        get "/api/v1/items/find_all?min_price=20"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(3)
        expect(items[:data][0][:id]).to eq(@gold_ring.id.to_s)
        expect(items[:data][1][:id]).to eq(@thing.id.to_s)
        expect(items[:data][2][:id]).to eq(@turing_shirt.id.to_s)
      end

      it "returns an empty array of json objects when there are no matches for min price parameters" do
        get "/api/v1/items/find_all?min_price=20000"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(0)
      end

      it "returns an array of all items less than max price parameter given" do
        get "/api/v1/items/find_all?max_price=50"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(2)
        expect(items[:data][0][:id]).to eq(@turing_hat.id.to_s)
        expect(items[:data][1][:id]).to eq(@turing_shirt.id.to_s)
      end

      it "returns an empty array of json objects when there are no matches for max price parameters" do
        get "/api/v1/items/find_all?max_price=10"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(0)
      end

      it "returns an array of all items between min and max price parameters given" do
        get "/api/v1/items/find_all?max_price=75&min_price=20"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(2)
        expect(items[:data][0][:id]).to eq(@gold_ring.id.to_s)
        expect(items[:data][1][:id]).to eq(@turing_shirt.id.to_s)
      end

      it "returns an empty array of json objects when there are no matches for min/max price parameters" do
        get "/api/v1/items/find_all?min_price=1&max_price=10"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(0)
      end
    end

    it "returns a 400 error when name and min parameters are given" do
      get "/api/v1/items/find_all?min_price=1&name=ring"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end

    it "returns a 400 error when name and max parameters are given" do
      get "/api/v1/items/find_all?max_price=1&name=ring"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end

    it "returns a 400 error when name, min and max parameters are given" do
      get "/api/v1/items/find_all?min_price=1&max_price=2&name=ring"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end

    it "returns a 400 error when min or max parameters are less than 0" do
      get "/api/v1/items/find_all?min_price=-1"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end

    it "returns a 400 error when max parameters are less than 0" do
      get "/api/v1/items/find_all?max_price=-1"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end

    it "returns a 400 error when min or max parameters are less than 0" do
      get "/api/v1/items/find_all?min_price=-1&max_price=4"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end

    it "returns a 400 error when no query parameters are included" do
      get "/api/v1/items/find_all"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end

    it "returns a 400 error when name parameter is given without value" do
      get "/api/v1/items/find_all?name"

      expect(response).to_not be_successful
      expect(response.status).to eq(400)

      item = JSON.parse(response.body, symbolize_names: true)

      expect(item[:message]).to eq("your query could not be completed")
      expect(item[:errors]).to eq(["Invalid query parameters"])
    end
  end
end