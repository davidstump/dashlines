# Facebook: Collect Likes and Share counts for the Fan pages.

like_count = 0
share_count = 0

SCHEDULER.every '10m', :first_in => 0 do |job|
  http = Net::HTTP.new('graph.facebook.com')
  response = http.request(Net::HTTP::Get.new("/#{ENV['FACEBOOK_PAGE_NAME']}"))
  like_count = JSON.parse(response.body)["likes"]

  response = http.request(Net::HTTP::Get.new("/?ids=http://#{ENV['FACEBOOK_SHARES_URL']}"))
  share_count = JSON.parse(response.body)["http://#{ENV['FACEBOOK_SHARES_URL']}"]["shares"]
end

SCHEDULER.every '5s', :first_in => 0 do |job|
  status = [[like_count, "Fans"], [share_count, "Shares"]].sample
  send_event('facebook', { value: status.first, moreinfo: status.last })
end
