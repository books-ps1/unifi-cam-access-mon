#!/usr/bin/env ruby
require 'json'
require 'active_support'
require 'active_support/core_ext'

# This regular expression matches user connection entries in the service.log
# of a Unifi camera.
PCRE = /\A(\d+-\d+-\d+T\d+:\d+:\d+\.\d+Z)\s+-\s+info:\s+User\s+(.+)\s+connected\. PEER ID:\s+/

# Set the time zone
Time.zone = "Central Time (US & Canada)"

WWW_ROOT = "/var/www/html"
WWW_DIR = "accessmon"
OUT_DIR = "#{WWW_ROOT}/#{WWW_DIR}"
OUT_TEXT_PATH = "#{OUT_DIR}/access.txt"
OUT_XML_PATH = "#{OUT_DIR}/access.xml"
OUT_JSON_PATH = "#{OUT_DIR}/access.json"
OUT_HTML_PATH = "#{OUT_DIR}/index.html"

# USAGE:
#   ./readlog.rb ./logs/service.log
#
filename = ARGV[0]
raise "Invalid log filename: #{filename}. Must match *.log" unless filename =~ /log\z/

# This array collects the information from all the matching lines
output_array = []

File.new(filename, 'r').each_line do |line|
  if line =~ PCRE
    timestamp, username, peer_id = $1, $2, $'.strip
    output_array.push( { line: line,
                         timestamp: timestamp,
                         username: username,
                         peer_id: peer_id } )
  end
end

# Output lines to access.txt
File.open(OUT_TEXT_PATH, 'w') do |out_text|
  output_array.each do |hash|
    out_text.puts hash[:line]
  end
end

# Output rich data to access.json and access.xml
last_hash = output_array.last
last_line = last_hash ? last_hash[:line] : "No lines found"
output_array.each do |hash|
  hash.delete(:line)
end
File.open(OUT_JSON_PATH, 'w') do |out_json|
  out_json.puts output_array.to_json
end
File.open(OUT_XML_PATH, 'w') do |out_xml|
  out_xml.puts output_array.to_xml
end

# Output the HTML index page that links the access logs and displays
# the latest entry and an update timestamp.
File.open(OUT_HTML_PATH, 'w') do |out_html|
  out_html.puts <<EOF
<html>
  <head>
    <title>Front Door Camera Access Logs</title>
  </head>
  <body>
  <h1>Front Door Camera Access Logs</h1>
  <h2>Last updated: #{Time.zone.now}</h2>
  <h2>Last access:</h2>
  <div>
    <pre>#{last_line}</pre>
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
end
