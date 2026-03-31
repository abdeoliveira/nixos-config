#!/usr/bin/env ruby

agenda_file = '/tmp/gcalcli_agenda.txt'

event = File.readlines(agenda_file)[1] if File.file? agenda_file

if event.nil? 
  string = ''
else
  start_date, start_time, end_date, end_time, title = event.split("\t")
  string = " [#{start_time}] #{title.strip}"
end

puts string
