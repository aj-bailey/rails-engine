require 'rails_helper'

RSpec.describe 'Merchant API' do
  describe 'Merchant Index API' do
    it 'sends a list of merchants' do
      create_list(:merchant, 10)

      get api_v1_merchants_path

      expect(response).to be_successful

      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants.count).to eq(10)

      merchants.each do |merchant|
        expect(merchant).to have_key(:id)
        expect(merchant[:id]).to be_an(Integer)
        
        expect(merchant).to have_key(:name)
        expect(merchant[:name]).to be_a(String)
      end
    end
  end

  describe 'Merchant Show API' do
    it 'sends a single merchant by its id' do
      merchant_1 = create(:merchant)

      get api_v1_merchant_path(merchant_1)

      expect(response).to be_successful
      expect(response.status).to eq(200)

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:id]).to eq(merchant_1.id)
      expect(merchant[:id]).to be_an(Integer)

      expect(merchant[:name]).to eq(merchant_1.name)
      expect(merchant[:name]).to be_a(String)
    end

    it 'sends a 404 status error when merchant id not found' do
      get api_v1_merchant_path(1)

      expect(response.status).to eq(404)
      expect(response.body).to eq("404 Not Found")
    end
  end
end