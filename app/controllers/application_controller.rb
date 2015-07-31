class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :prepare_unobtrusive_flash

  def render_404(value)
    raise ActionController::RoutingError.new(value)
  end

  def find_user
    @user = User.where("handle = ? or twitter = ?", params[:user_id], params[:user_id]).try(:first)
    @user = User.where("handle = ? or twitter = ?", current_user.handle, current_user.twitter).try(:first) if current_user && @user.blank?
  end


  def get_user
    find_user
    render_404("User #{params[:user_id]} not found") if @user.nil?
  end

  def get_wishlist
    @wishlist = Wishlist.first
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || (current_user.sign_in_count == 1 ? first_user_home_path(current_user) : user_home_path(current_user))
  end

end
