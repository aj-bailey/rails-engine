# Customer model
# frozen_string_literal: true.

class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
end
