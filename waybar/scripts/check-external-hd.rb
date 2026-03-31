#!/usr/bin/env ruby

def drive_mounted?
  uuid = ENV['EXTERNAL_HD_UUID']
  return false if uuid.nil? || uuid.empty?

  status = `lsblk -no MOUNTPOINT /dev/disk/by-uuid/#{uuid} 2>/dev/null`.strip
  !status.empty?
end

if drive_mounted?
  string = "| 󱊞 active"
else
  string = ''
end

puts string
