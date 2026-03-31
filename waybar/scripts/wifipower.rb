#!/usr/bin/env ruby

ssid, signal, active = `nmcli --fields ssid,signal,active --terse dev wifi | grep 'yes'`.split(':')

signal = signal.to_i

icon = '󰤮'

if signal > 0  then icon = '󰤯' end
if signal > 20 then icon = '󰤟' end
if signal > 40 then icon = '󰤢' end
if signal > 60 then icon = '󰤥' end
if signal > 80 then icon = '󰤨' end

puts "#{icon} #{ssid}"
