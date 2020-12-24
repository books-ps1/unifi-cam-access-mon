#!/usr/bin/env ruby
#
# ActiveRecord and AccessLine must be initialized first for this to work.
# See render.rb as an example.
#
require 'dotenv/load'
require 'active_record'

#
# Class to generate html output from a database connection
#
class HtmlController

  # @param path [String] the path to the html file to write
  def self.write(path = "#{ENV['WWW_ROOT']}/#{ENV['WWW_DIR']}/index.html")
    controller = self.new
    return controller.write
  end

  # @return [String]
  def www_dir
    return ENV['WWW_DIR']
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
    <a href='/#{www_dir}/access.txt'>Text version</a>
  </div>
  <div>
    <a href='/#{www_dir}/access.xml'>XML version</a>
  </div>
  <div>
    <a href='/#{www_dir}/access.json'>JSON version</a>
  </div>
  </body>
</html>
EOF
    return html_code
  end

  # @param path [String] the path to the html file to write
  def write(path = "#{ENV['WWW_ROOT']}/#{ENV['WWW_DIR']}/index.html")
    File.open(path, 'w') do |out_html|
      out_html.puts self.render
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

  HtmlController.write
end
