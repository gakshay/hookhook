class UsersController < ApplicationController
  before_action :set_user, only: [:finish_signup]


  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        UserMailer.welcome_email(@user).deliver unless @user.email.blank?
        sign_in(@user, :bypass => true)
      else
        @show_errors = true
      end
    end
  end


  private
  def set_user
    @user = current_user
  end

  def user_params
    accessible = [ :name, :email, :handle ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end