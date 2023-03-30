class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  validates_presence_of :name, :description, :unit_price, :merchant_id
  validates_numericality_of :unit_price

  def self.find_items_by_name(keyword)
    where("name ILIKE ?", "%#{keyword}%")
      .order(:name)
  end

  def self.find_items_above_or_eq_price(price)
    where("unit_price >= ?", price)
      .order(:name)
  end

  def self.find_items_below_or_eq_price(price)
    where("unit_price <= ?", price)
      .order(:name)
  end

  def self.find_items_between_prices(min, max)
    where("unit_price >= ? AND unit_price <= ?", min, max)
      .order(:name)
  end
end
