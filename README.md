# unifi-cam-access-mon
Read and parse the log file from a Unifi camera to filter and post the recent users

## Setup Instructions

This program writes files in the default web server file location under the accessmon directory.
The accessmon directory must first be created and given write permissions for the user that runs this script.

## Scripts

### log_to_db.rb

Read the locally downloaded log and save new unique access lines to the DB

### render.rb

Create text, JSON, and XML files based on the contents of the database.
Write an HTML index page to link them.

### readlog.rb

Read the locally downloaded log and write the contents to the HTML directory.
Does the work of log_to_db.rb and render.rb without a DB intermediary.

### db_count.rb

A sanity check program that outputs a count of all AccessLine records in the DB.

### cronscript.sh

The script that downloads the logs, and then calls log_to_db.rb and render.rb
to save and render them.

