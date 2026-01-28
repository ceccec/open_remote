module ValueUtil
  module_function

  # Valid when value is nil or a positive Integer.
  def validate_positive_integer(value)
    return true if value.nil?
    value.is_a?(Integer) && value.positive?
  end

  # Valid when value is nil or an Array of positive Integers.
  def validate_array_of_positive_integers(value)
    return true if value.nil?
    return false unless value.is_a?(Array)

    value.all? { |v| v.is_a?(Integer) && v.positive? }
  end

  # Valid when value is nil or a 2D Array (Array of Arrays) of positive Integers.
  def validate_array_of_array_of_positive_integers(value)
    return true if value.nil?
    return false unless value.is_a?(Array)

    value.all? do |row|
      row.is_a?(Array) && row.all? { |v| v.is_a?(Integer) && v.positive? }
    end
  end
end
