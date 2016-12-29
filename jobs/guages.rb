# Ping Guag.es every 10 seconds for the latest traffic details
SCHEDULER.every '10m', first_in: 0 do
  ga = Gauges.new(:token => ENV['GAUGES_TOKEN'])
  gauges = Hashie::Mash.new(ga.gauges).gauges
  site = gauges.detect {|g| g.title == ENV['APP_DOMAIN'] }
  people = site.recent_days.map.with_index{ |day, i| {x: i, y: day.people } }.reverse
  views = site.recent_days.map.with_index{ |day, i| {x: i, y: day.views } }.reverse
  send_event('gauges', points: people, pointsTwo: views )
  # send_event('gauges', { current: 20, last: rand(20) })
end
