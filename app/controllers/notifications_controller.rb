class NotificationsController < ApplicationController
  before_action :set_notification, only: [:destroy]

  def create
    get_user
    @notification = @user.notifications.new(notification_params)
    @notification.sender = current_user
    @notification.save!
  end


  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: 'Notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      get_user
      @notification = @user.notifications.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def notification_params
      params.require(:notification).permit(:recipient_id, :message, :status)
    end
end
