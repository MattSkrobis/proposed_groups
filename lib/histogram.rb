module Histogram

  private

  def histogram(array)
    Hash[*array.group_by { |value| value }.flat_map { |key, value| [key, value.size] }]
  end

  def data_for_histogram(name)
    reject_strangers(name).flat_map do |_, details_hash|
      details_hash[:user_groups]
    end
  end
end
