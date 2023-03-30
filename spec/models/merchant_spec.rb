require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe '::find_merchant' do
    before(:each) do
      @turing = create(:merchant, name: "Turing")
      @ring_world = create(:merchant, name: "Ring World")
      @thing_world = create(:merchant, name: "Thing World")
    end

    it 'returns the first merchant found from alphabetical order results from case-insensitive keyword' do
      expect(Merchant.find_merchant("ring")).to eq(@ring_world)
      expect(Merchant.find_merchant("RiNg")).to eq(@ring_world)
    end

    it 'returns nil if no matches' do
      expect(Merchant.find_merchant("beer")).to eq(nil)
    end
  end
end
