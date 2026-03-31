#!/usr/bin/env ruby

file_brightness = '/tmp/monitor_current_brightness' 
file_contrast   = '/tmp/monitor_current_contrast'   

def get_current(m)
`ddcutil --display 1 getvcp #{m}`.split(':').last&.scan(/\d+/)&.map(&:to_i)&.min || 0
end

def read_cache(file)
  File.read(file).to_i if File.file?(file)
end

def monitor_plugged?
  `wlr-randr`.include? 'HDMI-A-1' 
end

current_brightness = read_cache(file_brightness)
current_contrast = read_cache(file_contrast)

if current_brightness.nil?
  current_brightness = get_current(10) 
  File.write(file_brightness, current_brightness)
end

if current_contrast.nil?
  current_contrast = get_current(12) 
  File.write(file_contrast, current_contrast)
end

icon = "󱄄"

puts "| #{icon} #{current_brightness}/#{current_contrast}" if monitor_plugged?


