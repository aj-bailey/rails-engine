class Api::V1::Merchants::SearchController < Api::ApiController
  def index
    return render_404 unless params.keys.include?("name")
    return render_400 if params[:name] == ""

    merchant = Merchant.find_merchant(params[:name])
    
    return render_json_with_status(200) unless merchant
    render json: MerchantSerializer.new(merchant), status: 200
  end
end
