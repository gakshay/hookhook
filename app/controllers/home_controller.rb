class HomeController < ApplicationController

  def index
    
  end

  def user_lookup
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_app_id
      config.consumer_secret     = Rails.application.secrets.twitter_app_secret
      config.access_token        = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
    end


    @suggestions = client.users(params[:query]).collect do |user|
      "'name': #{user.screen_name}"
    end
    render json: @suggestions
  end

end
