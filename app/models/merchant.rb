# frozen_string_literal: true.

# Merchant model
class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
end
