require 'twitter'


#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
Twitter.configure do |config|
  config.consumer_key = 'jl46ztnyjSF91RHg2lrog'
  config.consumer_secret = '8yOwzT2i51SZXrmAo2iixvJ3QN9Gnwtih7jK1yVONU'
  config.oauth_token = '1130138335-EMyDiIC7O8MbFJB7N4FvasHjyS9nD7nZ0dA80US'
  config.oauth_token_secret = '7owogLjQKBNu6xRSwx1IZtXHzPTCb51Hw2weUdVTg'
end

#search_term = URI::encode('#todayilearned')
user = "PhStockExchange"

SCHEDULER.every '10m', :first_in => 0 do |job|
  begin
    #tweets = Twitter.search("#{search_term}").results
    tweets = Twitter.user_timeline(user)

    if tweets
      tweets.map! do |tweet|
        { name: tweet.user.name, body: tweet.text, avatar: tweet.user.profile_image_url_https }
      end
      send_event('twitter_mentions', comments: tweets)
    end
  rescue Twitter::Error
    puts "\e[33mFor the twitter widget to work, you need to put in your twitter API keys in the jobs/twitter.rb file.\e[0m"
  end
end