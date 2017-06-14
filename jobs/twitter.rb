require 'twitter'

Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  config.oauth_token = ENV['TWITTER_OAUTH_TOKEN']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_SECRET']
end

search_term = URI::encode('littlelines ruby elixir')

SCHEDULER.every '10s', :first_in => 0 do |job|
  tweets = Twitter.search("#{search_term}").results
  if tweets && tweets.any?
    tweets.map! do |tweet|
      { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
    end
    send_event('twitter_mentions', comments: tweets)
  else
    placeholder = {
      name: 'davidstump',
      body: "Littlelines should tweet more. 0.o",
      avatar: 'https://pbs.twimg.com/profile_images/672429352080945152/3h3IAuD0_bigger.png'
    }

    send_event('twitter_mentions', comments: [placeholder])
  end
end
