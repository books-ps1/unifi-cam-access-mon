#!/bin/bash

# Copy the service.log file
scp root@unificam:/srv/unifi-protect/logs/service.log logs/.

# Convert the log file into database records
./log_to_db.rb logs/service.log
# ./readlog.rb logs/service.log

# Generate pages based on database information
./render.rb
