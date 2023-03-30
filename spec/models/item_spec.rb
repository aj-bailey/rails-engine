require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :merchant_id }

    it { should validate_numericality_of :unit_price}
  end

  describe "::class methods" do
    describe "::find_items_by_name" do
      before(:each) do
        @turing_hat = create(:item, name: "Turing Hat")
        @turing_shirt = create(:item, name: "Turing Shirt")
        @gold_ring = create(:item, name: "Gold Ring")
        @thing = create(:item, name: "Thing")
      end

      it "returns the first merchant found from alphabetical order results from case-insensitive keyword" do
        expect(Item.find_items_by_name("ring")).to eq([@gold_ring, @turing_hat, @turing_shirt])
        expect(Item.find_items_by_name("RiNg")).to eq([@gold_ring, @turing_hat, @turing_shirt])
      end

      it "returns empty array if no matches" do
        expect(Item.find_items_by_name("beer")).to eq([])
      end
    end

    context "Pricing" do
      before(:each) do
        @turing_hat = create(:item, name: "Turing Hat", unit_price: 19.99)
        @turing_shirt = create(:item, name: "Turing Shirt", unit_price: 24.99)
        @gold_ring = create(:item, name: "Gold Ring", unit_price: 74.99)
        @thing = create(:item, name: "Thing", unit_price: 10_000.99)
      end

      describe "::find_items_above_or_eq_price" do
        it "returns the first merchant found from alphabetical order results above min price" do
          expect(Item.find_items_above_or_eq_price(24.99)).to eq([@gold_ring, @thing, @turing_shirt])
        end

        it "returns empty array if no matches" do
          expect(Item.find_items_above_or_eq_price(100_000)).to eq([])
        end
      end

      describe "::find_items_below_or_eq_price" do
        it "returns the first merchant found from alphabetical order results above min price" do
          expect(Item.find_items_below_or_eq_price(24.99)).to eq([@turing_hat, @turing_shirt])
        end

        it "returns empty array if no matches" do
          expect(Item.find_items_below_or_eq_price(1)).to eq([])
        end
      end

      describe "::find_items_below_or_eq_price" do
        it "returns the first merchant found from alphabetical order results above min price" do
          expect(Item.find_items_between_prices(20, 75)).to eq([@gold_ring, @turing_shirt])
        end

        it "returns empty array if no matches" do
          expect(Item.find_items_between_prices(1, 2)).to eq([])
        end
      end
    end
  end
end
