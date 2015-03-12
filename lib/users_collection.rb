class UsersCollection
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
    group_hashes = user_hash.inject({}) do |result, (key, value)|
      result[key] = suggested_groups_for(key)
      result
    end
    group_hashes.map do |key, value|
      "#{key}:#{value.join(',')}"
    end.join("\n") << "\n"
  end

  def suggested_groups_for(name)
    # znaleźć przyjaciół osoby name
    # wykluczyć nieprzyjaciół z user_hash (klucz-imię nie jest wśrod przyjaciół name)
    # mapować po friends_user_hash żeby otrzymać zainteresowania przyjaciół (wyjdzie tablica) którą trzeba flat
    # policzyc ile razy jakie zainteresowanie się pojawiło (histogram)
    # zwrocić metodzie suggested_groups tablice zainteresowań jesli dane zainteresowanie pojawiło się w przynajmniej 50% przypadków
    friends_of_user = user_hash[name.to_s][:friends]
    friends_user_hash = user_hash.reject { |key| !friends_of_user.include?(key) }
    data_for_histogram = friends_user_hash.flat_map do |_, details_hash|
      details_hash[:user_groups]
    end
    histogram = Hash[*data_for_histogram.group_by { |v| v }.flat_map { |k, v| [k, v.size] }]
    histogram.select { |_, value| value >= (friends_of_user.count / 2) }.keys.sort
  end
end