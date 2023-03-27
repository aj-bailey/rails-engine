# Customer model
# frozen_string_literal: true.

class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
end
