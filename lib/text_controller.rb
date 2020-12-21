#!/usr/bin/env ruby
#
# This is an object-oriented version of readlog.rb
# Written to make it easier to transition to a database-centric solution.
#
require 'dotenv/load'
require 'active_record'

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

# Class to generate text output from a database connection
class TextController

  # @param path [String] the path to the text file to write
  def self.write(path = "#{ENV['WWW_ROOT']}/#{ENV['WWW_DIR']}/access.txt")
    controller = self.new
    return controller.write
  end

  # @return [String] text file of access log lines
  def render
    line_array = AccessLine.order(:timestamp).pluck(:line)
    return line_array.join("\n")
  end

  # @param path [String] the path to the text file to write
  def write(path = "#{ENV['WWW_ROOT']}/#{ENV['WWW_DIR']}/access.txt")
    File.open(path, 'w') do |out_text|
      out_text.puts self.render
    end
  end

end

if __FILE__ == $0
  TextController.write
end
