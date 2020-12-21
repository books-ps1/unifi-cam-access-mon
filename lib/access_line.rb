require 'active_record'

#
# This class is a representation of a user access line in the UnifiCam
# service log located at /srv/unifi-protect/logs/service.log
#
class AccessLine < ActiveRecord::Base
  # This regular expression matches user connection entries in the service.log
  # of a Unifi camera.
  PCRE = /\A(\d+-\d+-\d+T\d+:\d+:\d+\.\d+Z)\s+-\s+info:\s+User\s+(.+)\s+connected\. PEER ID:\s+/

  # Permit only one record where both the username and timestamp are the same
  validates :timestamp, uniqueness: { scope: :username }

  # Quick class method to check if a line matches.
  #
  # @param line [String] entry line, can be either an access line or not
  # @return [false, Array] false if no match, array of inner matches if match
  def self.match?(line)
    return line =~ PCRE ? [$1.strip, $2.strip, $'.strip] : false
  end

  # @param line [String, Hash] entry line, can be either an access line or not
  # @param timestamp [String, DateTime, nil]
  # @param username [String, nil]
  # @param peer_id [String, nil]
  def initialize(line, timestamp = nil, username = nil, peer_id = nil)
    # If the fields are passed as a hash, de-serialize them into variables
    if line.respond_to?(:to_hash)
      timestamp = line[:timestamp]
      username = line[:username]
      peer_id = line[:peer_id]
      line = line[:line]
    end

    # If only the line field is filled, parse the line to generate the other
    # fields. If the fields are all filled, re-serialize them as a Hash and
    # pass them to the super-class.
    if timestamp && username && peer_id
      super(timestamp: timestamp.strip,
            username: username.strip,
            peer_id: peer_id.strip,
            line: line.strip)
    else
      if line =~ PCRE
        timestamp, username, peer_id = $1, $2, $'

        super(timestamp: timestamp.strip,
              username: username.strip,
              peer_id: peer_id.strip,
              line: line.strip)
      else
        #
        # #initialize allows the :new method accept lines that haven't been
        # filtered yet. If the lines don't match the filter, an exception
        # is thrown.
        #
        # Generally it's better to use the :match class method to filter
        # unknown lines first. The results can be fed to :new so that the
        # filter stage isn't called twice.
        #
        raise "line does not match: `#{line}`"
      end
    end
  end

  # @return [String]
  def to_s
    return line
  end

  # @return [Hash]
  def to_hash
    return { timestamp: timestamp, username: username, peer_id: peer_id }
  end

  # @return [Array]
  def to_array
    return [ timestamp, username, peer_id ]
  end

end
