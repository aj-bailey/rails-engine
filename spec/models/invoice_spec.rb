require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many :transactions }
  end

  describe "::class methods" do
    describe "::single_item_invoices" do
      it "returns a list of invoices that only have the associated item" do
        merchant = create(:merchant)

        item_1 = create(:item, merchant: merchant)
        item_2 = create(:item, merchant: merchant)

        invoice_1 = create(:invoice, merchant: merchant)
        invoice_2 = create(:invoice, merchant: merchant)
        invoice_3 = create(:invoice, merchant: merchant)

        invoice_4 = create(:invoice, merchant: merchant)

        create(:invoice_item, item: item_1, invoice: invoice_1)
        create(:invoice_item, item: item_1, invoice: invoice_2)
        create(:invoice_item, item: item_1, invoice: invoice_3)
        create(:invoice_item, item: item_1, invoice: invoice_4)
        create(:invoice_item, item: item_2, invoice: invoice_4)

        expect(item_1.invoices.single_item_invoices).to contain_exactly(invoice_1, invoice_2, invoice_3)
      end
    end
  end
end
