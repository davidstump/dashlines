require 'net/http'
require 'json'

search_term = URI::encode(ENV['TWITTER_SEARCH_STRING'])
followers = 0
friends = 0
tweet_count = 0

SCHEDULER.every '30m', :first_in => 0 do |job|
  http = Net::HTTP.new('search.twitter.com')
  response = http.request(Net::HTTP::Get.new("/search.json?q=#{search_term}"))
  tweets = JSON.parse(response.body)["results"]
  if tweets
    tweets.map! do |tweet|
      { name: tweet['from_user'], body: tweet['text'], avatar: tweet['profile_image_url_https'] }
    end
    send_event('twitter_mentions', comments: tweets)
  end
end

SCHEDULER.every '30m', :first_in => 0 do |job|
  http = Net::HTTP.new('api.twitter.com')
  response = http.request(Net::HTTP::Get.new("/1/users/show.json?screen_name=#{ENV['TWITTER_SCREEN_NAME']}"))
  followers = JSON.parse(response.body)["followers_count"]
  friends = JSON.parse(response.body)["friends_count"]
  tweet_count = JSON.parse(response.body)["statuses_count"]
end

SCHEDULER.every '10m', :first_in => 0 do |job|
  status = [
    { value: followers, max: 500, moreinfo: "Followers" },
    { value: friends, max: 100, moreinfo: "Friends"},
    { value: tweet_count, max: 500, moreinfo: "Tweets"}
   ]
  send_event('twitter', status.sample)
end
