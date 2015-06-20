MandrillMailer.configure do |config|

  # for local environment set this key in your local .env file
  config.api_key = ENV['MANDRILL_API_KEY']
end


ActionMailer::Base.smtp_settings = {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :user_name => "akshay.aries11@gmail.com",
    :password  => ENV['MANDRILL_API_KEY'],
    :domain    => 'request.to'
}
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true