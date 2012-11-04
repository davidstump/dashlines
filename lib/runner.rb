require 'awesome_print'
require 'pp'
require 'rubygems'
require 'gauges'
require 'hashie'

ga = Gauges.new(:token => '8e3ba43a359d65a39af555944ba80c6b')
gauges = Hashie::Mash.new(ga.gauges).gauges
site = gauges.detect {|g| g.title == "littlelines.com" }
points = site.recent_days.map.with_index{ |day, i| {x: i, y: day.people } }

ap points
