#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'users_collection'

module FromFile

  def self.call
    user_collection_object.suggested_groups
  end

  private

  def self.user_collection_object
    UsersCollection.new(input_file.read)
  end

  def self.input_file
    File.open(file_path, "r")
  end

  def self.file_path
    ARGV[0]
  end



end

puts FromFile.call