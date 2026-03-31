#!/usr/bin/env ruby

permanent = false

delta_time = 0.5 
iface = ARGV[0] 
megabyte   = 1024 * 1024
kilobyte = 1024


def get_wifi_device_name
  output = `nmcli connection show --active`

  wifi_line = output.lines.find { |line| line.include?(' wifi ') }

  wifi_line&.split&.last
end

iface = get_wifi_device_name

exit 0 unless iface

def netdata(iface)
  data = `cat /proc/net/dev`
  dataline = data.split("\n")
  dataline.each do |l|
    device = l.split(" ")
    if device[0].include? iface
      @dl = device[1].to_f
      @ul = device[9].to_f
    end
  end
  return [@dl, @ul]
end

a = [0, 0]
b = [0, 0]
a = netdata(iface)
sleep delta_time
b = netdata(iface)

delta_dl = b[0] - a[0]
delta_ul = b[1] - a[1]

rx = delta_dl/megabyte/delta_time
tx = delta_ul/megabyte/delta_time
speed = (rx+tx).round(1).to_s + " Mb/s"

unless permanent
  if rx+tx <= 0.1 
    puts ""
  else
    if rx/tx > 4 
        puts " " + speed
    elsif tx/rx > 4
        puts " " + speed
    else
        puts " " + speed 
    end
  end
else
   puts " #{rx.round(1)} Mb/s  #{tx.round(1)} Mb/s"
end
