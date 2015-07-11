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
    @user = User.find_by_twitter(params[:user_id])
    @user = User.find_by_twitter(current_user.twitter) if current_user && @user.blank?
    render_404("User #{params[:twiter_handle]}") if @user.nil?
  end

  def get_wishlist
    @wishlist = Wishlist.first
  end

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || user_home_path(current_user)
  end

end
