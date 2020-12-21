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

# Class to generate html output from a database connection
class HtmlController

  # @param path [String] the path to the html file to write
  def self.write(path = "#{WWW_ROOT}/#{WWW_DIR}/index.html")
    controller = self.new
    return controller.write
  end

  # @return [String] html file of access log lines
  def render
    # Set the time zone
    Time.zone = "Central Time (US & Canada)"

    # Get the last access record
    last_line = AccessLine.order(:timestamp).last

    html_code =<<EOF
<html>
  <head>
    <title>Front Door Camera Access Logs</title>
  </head>
  <body>
  <h1>Front Door Camera Access Logs</h1>
  <h2>Last updated: #{Time.zone.now}</h2>
  <h2>Last access:</h2>
  <div>
    <pre>#{last_line.nil? ? 'no records' : last_line.line}</pre>
  </div>
  <div>
    <a href='/#{WWW_DIR}/access.txt'>Text version</a>
  </div>
  <div>
    <a href='/#{WWW_DIR}/access.xml'>XML version</a>
  </div>
  <div>
    <a href='/#{WWW_DIR}/access.json'>JSON version</a>
  </div>
  </body>
</html>
EOF
    return html_code
  end

  # @param path [String] the path to the html file to write
  def write(path = "#{WWW_ROOT}/#{WWW_DIR}/index.html")
    File.open(path, 'w') do |out_html|
      out_html.puts self.render
    end
  end

end

if __FILE__ == $0
  HtmlController.write
end
