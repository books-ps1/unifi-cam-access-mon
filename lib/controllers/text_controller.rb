#!/usr/bin/env ruby
#
# ActiveRecord and AccessLine must be initialized first for this to work.
# See render.rb as an example.
#
require 'dotenv/load'
require 'active_record'

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

# Run this code only if called as an executable script and
# not as a library file.
#
if __FILE__ == $0
  ActiveRecord::Base.establish_connection(
    :adapter  => 'postgresql',
    :encoding => 'unicode',
    :database => ENV['DB_NAME'], # accessmon
    :username => ENV['DB_USERNAME'], # accessmon
    :password => ENV['DB_PASSWORD'],
    :pool     => ENV['DB_POOL'], # 5
    :port     => ENV['DB_PORT'], # 5432
    :host     => ENV['DB_HOST']) # eg. localhost

  class AccessLine < ActiveRecord::Base
  end

  TextController.write
end
