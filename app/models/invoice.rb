class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  has_many :invoice_items, dependent: :destroy
  has_many :transactions

  def self.single_item_invoices
    joins(:invoice_items)
      .select("invoices.*, count(invoice_items.id)")
      .group(:id)
      .having("count(invoice_items.id) = ?", 1)
  end
end
