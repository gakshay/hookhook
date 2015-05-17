MandrillMailer.configure do |config|

  # for local environment set this key in your local .env file
  config.api_key = ENV['MANDRILL_API_KEY']
end