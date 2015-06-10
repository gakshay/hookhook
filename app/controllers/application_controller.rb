class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :prepare_unobtrusive_flash

  def render_404(value)
    respond_to do |format|
      format.html { render :controller => "home", :action => "index", error: "#{value} was not found", :status => 404 }
      format.json { render :json => {error: "#{value} not found"}, :status => 404 }
    end
  end

  def get_user
    @user = User.find_by_twitter(params[:twitter_handle] || params[:user_id])  unless params[:twitter_handle].blank? || params[:user_id].blank?
    @user = User.find_by_twitter(current_user.twitter) if current_user && @user.blank?
    render_404("User #{params[:twiter_handle]}") if @user.nil?
  end

  def get_wishlist
    @wishlist = Wishlist.first
  end

end
