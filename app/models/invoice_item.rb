# frozen_string_literal: true.

# Invoice Item model
class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
end
