require 'rails_helper'

RSpec.describe "Merchants Search API" do
  describe "Merchants Search Index API" do
    it "sends the first merchant found from case-insensitive alphabetical order results" do
      turing = create(:merchant, name: "Turing")
      ring_world = create(:merchant, name: "Ring World")
      thing_world = create(:merchant, name: "Thing World")

      get "/api/v1/merchants/find?name=ring"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data][:id]).to eq(ring_world.id.to_s)
      expect(merchant[:data][:id]).to be_an(String)

      expect(merchant[:data][:attributes][:name]).to eq(ring_world.name)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
    end

    it 'sends a 400 status error with merchant object when no name parameters are given' do
      get "/api/v1/merchants/find?name="

      expect(response.status).to eq(400)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:message]).to eq("param is missing or the value is empty")
      expect(merchant[:errors]).to eq(["Missing query parameter"])
    end

    it 'sends a 200 status code with empty object when no results found' do
      get "/api/v1/merchants/find?name=asdf"

      expect(response.status).to eq(200)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data][:id]).to eq(nil)
      expect(merchant[:data][:type]).to eq("merchant")
      expect(merchant[:data][:attributes][:name]).to eq(nil)
    end
  end
end