class HomeController < ApplicationController

  def index
    @subscriber = Subscriber.new
    find_user
    if @user.present?
      get_wishlist
      get_user_request_details
      @other_users = User.timeline_users(@user)
    end
  end

  def user_lookup
    @users = CLIENT.user_search(params[:query])
    render json: @users
  end

end
