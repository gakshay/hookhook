class HomeController < ApplicationController

  def index
    @subscriber = Subscriber.new
    find_user
    if @user.present?
      get_wishlist
      @following = @user.requests.unanswered.where(:wishlist_id => @wishlist.id)
      @admirers = @user.admirers.where(:wishlist_id => @wishlist.id)
      @conversations = @user.requests.answered.where(:wishlist_id => @wishlist.id)
      @other_users = User.timeline_users(@user)
    end
  end

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

  def show
    redirect_to root_path if current_user.blank?
  end

end
