class Api::V1::Items::SearchController < Api::ApiController
  def index
    return raise ActionController::BadRequest.new, "Invalid query parameters" unless valid_query_params?

    items = execute_query

    return render json: ItemSerializer.new([]), status: 200 if items.empty?
    render json: ItemSerializer.new(items), status: 200
  end

  private

  def execute_query
    if has_name_param?
      Item.find_items_by_name(params[:name])
    elsif has_min_price_param? && has_max_price_param?
      min_and_max_price
    elsif has_min_price_param?
      min_price
    elsif has_max_price_param?
      max_price
    end
  end

  def valid_query_params?
    if has_name_param? && (has_min_price_param? || has_max_price_param?)
      return false
    elsif !has_name_param? && !has_min_price_param? && !has_max_price_param?
      return false
    end

    true
  end

  def min_and_max_price
    return Item.find_items_between_prices(params[:min_price], params[:max_price]) if valid_price?

    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def min_price
    return Item.find_items_above_or_eq_price(params[:min_price]) if valid_price?

    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def max_price
    return Item.find_items_below_or_eq_price(params[:max_price]) if valid_price?

    raise ActionController::BadRequest.new, "Invalid query parameters"
  end

  def valid_price?
    return true if params[:min_price].to_f >= 0 && params[:max_price].to_f >= 0

    false
  end

  def has_name_param?
    params.keys.include?("name")
  end

  def has_min_price_param?
    params.include?("min_price")
  end

  def has_max_price_param?
    params.include?("max_price")
  end
end