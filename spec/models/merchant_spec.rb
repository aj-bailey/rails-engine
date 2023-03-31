require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe "::find_merchant" do
    before(:each) do
      @turing = create(:merchant, name: "Turing")
      @ring_world = create(:merchant, name: "Ring World")
      @thing_world = create(:merchant, name: "Thing World")
    end

    it "returns the first merchant found from alphabetical order results from case-insensitive keyword" do
      expect(Merchant.find_merchant("ring")).to eq(@ring_world)
      expect(Merchant.find_merchant("RiNg")).to eq(@ring_world)
    end

    it "returns nil if no matches" do
      expect(Merchant.find_merchant("beer")).to eq(nil)
    end
  end

  describe "::paginate" do
    before(:each) do
      @merchant_1 = create(:merchant)
      create_list(:merchant, 9)

      @merchant_11 = create(:merchant)
      create_list(:merchant, 9)

      @merchant_21 = create(:merchant)
      create_list(:merchant, 19)

      @merchant_41 = create(:merchant)
    end

    it "returns the first twenty merchants when given no parameters" do
      expect(Merchant.paginate.first).to eq(@merchant_1)
      expect(Merchant.paginate.count).to eq(20)
      expect(Merchant.paginate[20]).to_not eq(@merchant_21)
    end

    it "returns the first 'per_page' merchants when given per_page argument without page" do
      argument = { per_page: 10 }

      expect(Merchant.paginate(argument).first).to eq(@merchant_1)
      expect(Merchant.paginate(argument).count).to eq(10)
      expect(Merchant.paginate(argument)[10]).to_not eq(@merchant_11)
    end

    it "returns 20 merchants starting on page 'page' when given page argument without per_page" do
      argument = { page: 2 }

      expect(Merchant.paginate(argument).first).to eq(@merchant_21)
      expect(Merchant.paginate(argument).count).to eq(20)
      expect(Merchant.paginate(argument)[10]).to_not eq(@merchant_41)
    end

    it "returns 'per_page' merchants starting on page 'page' when given both arguments" do
      argument = { page: 2, per_page: 10 }

      expect(Merchant.paginate(argument).first).to eq(@merchant_11)
      expect(Merchant.paginate(argument).count).to eq(10)
      expect(Merchant.paginate(argument)[10]).to_not eq(@merchant_21)
    end
  end
end
