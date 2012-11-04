# Retrieves you overall Sliqr score.

SCHEDULER.every '10m', :first_in => 0 do |job|
  http = Net::HTTP.new('api.sliqr.com')
  response = http.request(Net::HTTP::Get.new("/v1.0/users/#{ENV['SLIQR_TOKEN']}"))
  score = JSON.parse(response.body)["score"]
  send_event('sliqr', { current: score, last: 10 })
end

