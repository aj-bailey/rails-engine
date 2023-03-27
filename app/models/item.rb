# frozen_string_literal: true.

# Item model
class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
end
