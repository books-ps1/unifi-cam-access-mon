#!/usr/bin/env ruby
#
require 'dotenv/load'
require_relative './lib/models/access_line'

log_file_path = ARGV[0]

# The database must already exist for this script to work.
# Create or migrate the database with migrate.rb
ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :encoding => 'unicode',
  :database => ENV['DB_NAME'], # accessmon
  :username => ENV['DB_USERNAME'], # accessmon
  :password => ENV['DB_PASSWORD'],
  :pool     => 5,
  :port     => 5432,
  :host     => 'localhost')

File.new(log_file_path, 'r').each_line do |line|
  match = AccessLine.match?(line)
  if match
    timestamp, username, peer_id = match
    AccessLine.create(line: line,
                      username: username,
                      timestamp: timestamp,
                      peer_id: peer_id)
  end
end
