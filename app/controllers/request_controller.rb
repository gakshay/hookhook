class RequestController < ApplicationController

  def create

    @user = User.where(provider: 'twitter', uid: params[:id]).first_or_create do |user|
      user.name = params[:name]
      user.image = params[:profile_image_url]
      user.twitter = params[:screen_name]
      user.description = params[:description]
    end

    if @user.persisted?
      @request = Request.new(:from => current_user.id, :to => @user.id, :status => 0, :wishlist => Wishlist.first)
      if @request.save
        render :js => "alert('user added');"
      end
    end

  end

end
