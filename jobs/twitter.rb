require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token = ENV['TWITTER_OAUTH_TOKEN']
  config.access_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

search_term = URI::encode('littlelines')

SCHEDULER.every '10m', :first_in => 0 do |job|
  tweets = client.search("#{search_term}").take(10)
  if tweets
    tweets.map! do |tweet|
      { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
    end
    send_event('twitter_mentions', comments: tweets)
  end
end
