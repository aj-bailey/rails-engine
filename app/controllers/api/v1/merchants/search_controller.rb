class Api::V1::Merchants::SearchController < Api::ApiController
  def index
    if params[:name] == "" || !params[:name]
      raise ActionController::ParameterMissing.new "Missing query parameter"
    else
      render_merchant_json
    end
  end

  private

  def render_merchant_json
    merchant = Merchant.find_merchant(params[:name])

    return render json: MerchantSerializer.new(Merchant.new), status: 200 unless merchant

    render json: MerchantSerializer.new(merchant), status: 200
  end
end
