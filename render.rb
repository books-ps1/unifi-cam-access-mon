#!/usr/bin/env ruby
#
require 'dotenv/load'
require_relative './lib/controllers/text_controller'
require_relative './lib/controllers/json_controller'
require_relative './lib/controllers/xml_controller'
require_relative './lib/controllers/html_controller'

if __FILE__ == $0
  TextController.write
  JsonController.write
  XmlController.write
  HtmlController.write
end
