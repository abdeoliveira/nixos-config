#!/usr/bin/env ruby
require 'socket'

# Internet check: try a TCP connection to well-known IPs (no DNS involved).
# Each attempt gives up after `timeout` seconds.
def online?(hosts = [['1.1.1.1', 443], ['8.8.8.8', 443]], timeout: 1)
  hosts.any? do |host, port|
    Socket.tcp(host, port, connect_timeout: timeout).close
    true
  rescue StandardError
    false
  end
end

device = `iw dev`[/Interface\s+(\S+)/, 1]

data_hash = {}
if device
  `iw dev #{device} link 2>/dev/null`.each_line do |line|
    key, value = line.split(':', 2)   # split only on the first colon
    next unless value                 # skips lines like "Not connected."
    data_hash[key.strip] = value.strip
  end
end

ssid = data_hash['SSID']
signal_dbm = data_hash.fetch('signal', '-100').to_f

signal = ((signal_dbm + 100) * 2).clamp(0, 100)

icon = '󰤮'

if signal > 0  then icon = '󰤯' end
if signal > 20 then icon = '󰤟' end
if signal > 40 then icon = '󰤢' end
if signal > 60 then icon = '󰤥' end
if signal > 80 then icon = '󰤨' end

no_internet = "\u{F0164}" # nf-md-cloud_off_outline

parts = []
parts << no_internet unless online?
parts << icon
parts << ssid if ssid

puts parts.join(' ')
