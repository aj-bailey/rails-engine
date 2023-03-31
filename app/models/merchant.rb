class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices

  DEFAULT_PAGINATE = {
    per_page: 20,
    page: 1
  }

  def self.find_merchant(keyword)
    where("name ILIKE ?", "%#{keyword}%")
      .order(:name)
      .first
  end
  
  def self.paginate(paginate_params = {})
    paginate_params = DEFAULT_PAGINATE.merge(paginate_params)
    
    offset = (paginate_params[:page] - 1) * paginate_params[:per_page]

    limit(paginate_params[:per_page])
      .offset(offset)
  end
end
