class HomeController < ApplicationController

  # before_action :get_user, :only => [:index]
  #
  # def index
  #   @wishlist = Wishlist.first
  #   @following = @user.requests.where(:wishlist_id => @wishlist.id)
  #   @followers = Request.where(:to => @user.id).count
  # end

  def user_lookup
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.twitter_app_id
      config.consumer_secret     = Rails.application.secrets.twitter_app_secret
      config.access_token        = Rails.application.secrets.twitter_access_token
      config.access_token_secret = Rails.application.secrets.twitter_access_token_secret
    end

    @users = client.user_search(params[:query])
    render json: @users
  end

end
