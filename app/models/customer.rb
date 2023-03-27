# frozen_string_literal: true.

# Customer model
class Customer < ApplicationRecord
  has_many :invoices
end
