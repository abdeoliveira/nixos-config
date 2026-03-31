#!/usr/bin/env ruby

def read_code(label)
  code = nil
  config_path = "#{ENV['HOME']}/.cache/simplecron"
  code_file = "#{config_path}/#{label}.code"
  code = File.read(code_file) if File.file? code_file
  return code
end

config_file = "#{ENV['HOME']}/.config/simplecron/config"

data = File.readlines(config_file)

failed_job = []
nil_job = []
success_job = []

data.each do |line|
  unless line.include? '#'
    label = line.split(',').first
    code = read_code(label)
    if code.nil?
      nil_job << label 
    else
      failed_job << label if code != '0'
      success_job << label if code == '0'
    end
  end
end

puts "| 󰀦 #{failed_job}" unless failed_job.empty?
