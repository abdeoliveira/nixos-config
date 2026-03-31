#!/usr/bin/env ruby

vpn_string = 'tun0'

data = `ip a`

icon = ''
icon = '' if data.include? vpn_string

puts icon

