#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'users_collection'

module FromFile

  def self.call
    users_per_line = File.open(ARGV[0], "r").read
    UsersCollection.new(users_per_line).suggested_groups
  end
end

puts FromFile.call