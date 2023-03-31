class Api::V1::MerchantsController < Api::ApiController
  def index
    merchants = Merchant.paginate(validated_params)

    return render json: MerchantSerializer.new([]), status: 200 if merchants.empty?

    render json: MerchantSerializer.new(merchants), status: 200
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  private

  def validated_params
    validated_params = { per_page: validated_per_page, page: validated_page }
    validated_params.compact!

    validated_params.delete(:per_page) unless validated_params[:per_page].present? && validated_params[:per_page].positive?
    validated_params.delete(:page) unless validated_params[:page].present? && validated_params[:page].positive?

    validated_params
  end

  def validated_per_page
    return nil if params[:per_page].nil?
    return params[:per_page].to_i if params[:per_page].to_i.positive?
    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def validated_page
    return nil if params[:page].nil?
    return params[:page].to_i if params[:page].to_i.positive?
    raise ActionController::BadRequest.new, "Invalid query parameters"
  end
end