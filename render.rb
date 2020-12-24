#!/usr/bin/env ruby
#
require 'dotenv/load'
require_relative './lib/controllers/text_controller'
require_relative './lib/controllers/json_controller'
require_relative './lib/controllers/xml_controller'
require_relative './lib/controllers/html_controller'

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

  # Write the file containing all access lines from the db
  TextController.write

  # Write the rich data files in JSON and XML
  JsonController.write
  XmlController.write

  # Write the HTML index file that links to the previously written files
  HtmlController.write
end
