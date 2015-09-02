CLIENT = Twitter::REST::Client.new do |config|
  config.consumer_key        = Rails.application.secrets.twitter_app_id
  config.consumer_secret     = Rails.application.secrets.twitter_app_secret
  config.access_token        = Rails.application.secrets.twitter_access_token
  config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
end