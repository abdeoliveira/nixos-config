#!/usr/bin/env ruby

#ssid, signal, active = `nmcli --fields ssid,signal,active --terse dev wifi | grep 'yes'`.split(':')

device = `iw dev | grep Interface`.split.last

data = `iw dev #{device} link`

data_hash = {}

data.split("\n").each do |line|
  key, value = line.split(':')
  data_hash[key.strip] = value.strip
end

ssid = data_hash['SSID']
signal_dbm = data_hash['signal'].to_f

signal = ((signal_dbm + 100) * 2).clamp(0, 100)

icon = '󰤮'

if signal > 0  then icon = '󰤯' end
if signal > 20 then icon = '󰤟' end
if signal > 40 then icon = '󰤢' end
if signal > 60 then icon = '󰤥' end
if signal > 80 then icon = '󰤨' end

puts "#{icon} #{ssid}"
