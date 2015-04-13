class RequestController < ApplicationController

  def create

    @user = User.where(provider: 'twitter', uid: params[:id]).first_or_create do |user|
      user.name = params[:name]
      user.image = params[:profile_image_url]
      user.twitter = params[:screen_name]
      user.description = params[:description]
    end

    if @user.persisted?
      @request = Request.where(:from => current_user.id, :to => @user.id).first_or_initialize
      if @request.new_record?
        @request.status = false
        @request.wishlist = Wishlist.first
        if @request.save
          render 'request/create'
        end
      else
        render :js => "alert('#{@user.name} is already added to your list');"
      end
    end

  end

  def destroy
    @request = current_user.requests.find_by_id(params[:id])

    respond_to do |format|
      if @request && @request.delete
        format.json { head :no_content }
      else
        format.json { render :json => 'User does not exist', :status => 400 }
      end
    end
  end

end
