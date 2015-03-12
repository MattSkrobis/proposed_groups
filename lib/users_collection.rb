require 'histogram'

class UsersCollection
  include Histogram
  attr_reader :user_hash
  LINE_PARSING_REGEXP = /(?<user_name>[^:]*):(?<friends>[^:]*):(?<interests>[^\n]*)/

  def initialize(data_string)
    @user_hash = data_string.each_line.inject({}) do |result, line|
      line_match = LINE_PARSING_REGEXP.match(line)
      result[line_match[:user_name]] = {friends: line_match[:friends].split(','), user_groups: line_match[:interests].split(',')}
      result
    end
  end

  def suggested_groups
    group_hashes = user_hash.inject({}) do |result, (user_name)|
      result[user_name] = suggested_groups_for(user_name)
      result
    end
    formatting_output(group_hashes)
  end

  def suggested_groups_for(name)
    histogram(data_for_histogram(name)).select { |_, value| value >= (user_hash[name.to_s][:friends].count / 2) }.keys.sort
  end

  private

  def formatting_output(group_hashes)
    group_hashes.map do |name, interests|
      "#{name}:#{interests.join(',')}"
    end.join("\n") << "\n"
  end

  def reject_strangers(name)
    user_hash.reject { |key| !user_hash[name.to_s][:friends].include?(key) }
  end
end