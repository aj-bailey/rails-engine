class Api::V1::Items::SearchController < Api::ApiController
  def index
    return raise ActionController::BadRequest.new(), "Invalid query parameters" unless valid_query_params?

    items = execute_query

    return render json: ItemSerializer.new([]), status: 200 if items.empty?
    render json: ItemSerializer.new(items), status: 200
  end

  private

  def execute_query
    if params.keys.include?("name")
      Item.find_items_by_name(params[:name])
    elsif params.keys.include?("min_price")
      min_price
    elsif params.keys.include?("max_price")
      max_price
    end
  end

  def valid_query_params?
    if params.keys.include?("name") && (params.include?("min_price") || params.include?("max_price"))
      return false
    elsif !params.keys.include?("name") && !params.include?("min_price") && !params.include?("max_price")
      return false
    end

    true
  end

  def min_price
    if params.keys.include?("max_price") && valid_price?
      Item.find_items_between_prices(params[:min_price], params[:max_price])
    elsif valid_price?
      Item.find_items_above_or_eq_price(params[:min_price])
    else
      raise ActionController::BadRequest.new(), "Invalid query parameters"
    end
  end

  def max_price
    if valid_price?
      Item.find_items_below_or_eq_price(params[:max_price])
    else
      raise ActionController::BadRequest.new(), "Invalid query parameters"
    end
  end

  def valid_price?
    return true if params[:min_price].to_f >= 0 && params[:max_price].to_f >= 0
    false
  end
end