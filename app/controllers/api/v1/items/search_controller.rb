class Api::V1::Items::SearchController < Api::ApiController
  def index
    return raise ActionController::BadRequest.new, "Invalid query parameters" unless valid_query_params?

    items = execute_query

    return render json: ItemSerializer.new([]), status: 200 if items.empty?
    render json: ItemSerializer.new(items), status: 200
  end

  private

  def execute_query
    if name_param?
      name_query
    elsif min_price_param? && max_price_param?
      min_and_max_price_query
    elsif min_price_param?
      min_price_query
    elsif max_price_param?
      max_price_query
    end
  end

  def valid_query_params?
    if name_param? && (min_price_param? || max_price_param?)
      return false
    elsif !name_param? && !min_price_param? && !max_price_param?
      return false
    end

    true
  end

  def name_query
    return Item.find_items_by_name(params[:name]) if params[:name].present?

    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def min_and_max_price_query
    return Item.find_items_between_prices(params[:min_price], params[:max_price]) if valid_price?

    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def min_price_query
    return Item.find_items_above_or_eq_price(params[:min_price]) if valid_price?

    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def max_price_query
    return Item.find_items_below_or_eq_price(params[:max_price]) if valid_price?

    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def valid_price?
    return true if params[:min_price].to_f >= 0 && params[:max_price].to_f >= 0

    false
  end

  def name_param?
    params.keys.include?("name")
  end

  def min_price_param?
    params.include?("min_price")
  end

  def max_price_param?
    params.include?("max_price")
  end
end