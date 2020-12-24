#!/usr/bin/env ruby
#
require 'dotenv/load'
require_relative './lib/models/access_line'

# The database must already exist for this script to work.
# Create or migrate the database with migrate.rb
ActiveRecord::Base.establish_connection(
  :adapter  => 'postgresql',
  :encoding => 'unicode',
  :database => ENV['DB_NAME'], # accessmon
  :username => ENV['DB_USERNAME'], # accessmon
  :password => ENV['DB_PASSWORD'],
  :pool     => ENV['DB_POOL'], # 5
  :port     => ENV['DB_PORT'], # 5432
  :host     => ENV['DB_HOST']) # eg. localhost

puts "Total records: #{AccessLine.count}"
