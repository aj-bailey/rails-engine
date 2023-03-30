class ErrorSerializer
  def initialize(error)
    @error = error
  end

  def serialized_json
    {
      "message": error_message,
      "errors": parse_error_message
    }
  end

  def error_message
    if @error.message.include?(":")
      @error.message.split(":")[0]
    else
      "your query could not be completed"
    end
  end

  def parse_error_message
    return [@error.message] unless @error.message.include?(":")

    colon_index = @error.message.index(":")
    @error.message[(colon_index + 2)..-1].split(", ")
  end
end