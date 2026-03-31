#!/usr/bin/ruby
#location = 'Cachoeira+do+Campo'
location = 'Cachoeira+do+Campo'
fetch = `curl -s wttr.in/#{location}?format=%t`
#city = fetch.split[0].delete(',')
#icon = fetch.split[2]
#temp = fetch.split[3]
puts "#{fetch}"
