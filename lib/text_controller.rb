#!/usr/bin/env ruby
#
# This is an object-oriented version of readlog.rb
# Written to make it easier to transition to a database-centric solution.
#
require 'dotenv/load'
require 'active_record'

WWW_ROOT = "/var/www/html"
WWW_DIR = "accessmon"
OUT_DIR = "#{WWW_ROOT}/#{WWW_DIR}"

POOL_COUNT = 5
PORT_NUMBER = 5432

ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :encoding => 'unicode',
  :database => ENV['DB_NAME'], # accessmon
  :username => ENV['DB_USERNAME'], # accessmon
  :password => ENV['DB_PASSWORD'],
  :pool     => POOL_COUNT,
  :port     => PORT_NUMBER,
  :host     => 'localhost')

class AccessLine < ActiveRecord::Base
end

# Class to generate text output from a database connection
class TextController

  # @param path [String] the path to the text file to write
  def self.write(path = "#{WWW_ROOT}/#{WWW_DIR}/access.txt")
    controller = self.new
    return controller.write
  end

  # @return [String] text file of access log lines
  def render
    line_array = AccessLine.order(:timestamp).pluck(:line)
    return line_array.join("\n")
  end

  # @param path [String] the path to the text file to write
  def write(path = "#{WWW_ROOT}/#{WWW_DIR}/access.txt")
    File.open(path, 'w') do |out_text|
      out_text.puts self.render
    end
  end

end

if __FILE__ == $0
  TextController.write
end
