#!/usr/bin/env ruby
#
# This is an object-oriented version of readlog.rb
# Written to make it easier to transition to a database-centric solution.
#
require 'dotenv/load'
require_relative './access_line'
require 'json'

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :encoding => 'unicode',
  :database => ENV['DB_NAME'], # accessmon
  :username => ENV['DB_USERNAME'], # accessmon
  :password => ENV['DB_PASSWORD'],
  :pool     => 5,
  :port     => 5432,
  :host     => 'localhost')

class AccessLine < ActiveRecord::Base
end

# Class to generate json output from a database connection
class JsonController

  # @param path [String] the path to the json file to write
  def self.write(path = "#{ENV['WWW_ROOT']}/#{ENV['WWW_DIR']}/access.json")
    controller = self.new
    return controller.write
  end

  # @return [String] json file of access log lines
  def render
    hash_array = AccessLine.order(:timestamp).map(&:to_hash)
    return hash_array.to_json
  end

  # @param path [String] the path to the json file to write
  def write(path = "#{ENV['WWW_ROOT']}/#{ENV['WWW_DIR']}/access.json")
    File.open(path, 'w') do |out_json|
      out_json.puts self.render
    end
  end

end

if __FILE__ == $0
  JsonController.write
end
