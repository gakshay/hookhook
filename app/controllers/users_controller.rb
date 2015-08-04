class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:finish_signup, :username]
  before_action :set_user, only: [:finish_signup, :username]


  def channel
    redirect_to root_path if current_user.blank?
  end

  def username
    user_params[:handle] = @user.twitter if params[:set_twitter_as_username] == true
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_home_path(current_user)}
        format.json { render :show, status: :updated, location: @user }
      else
        format.html { redirect_to channel_user_path(current_user), alert: @user.errors.full_messages.to_sentence }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

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
    accessible = [ :name, :email, :handle, :handle_flag ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end
end