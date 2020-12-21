#!/usr/bin/env ruby
#
require 'dotenv/load'
require_relative './lib/text_controller'
require_relative './lib/json_controller'
require_relative './lib/xml_controller'
require_relative './lib/html_controller'

if __FILE__ == $0
  TextController.write
  JsonController.write
  XmlController.write
  HtmlController.write
end
