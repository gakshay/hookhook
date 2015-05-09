class ReportsController < ApplicationController
  # before_action :authenticate_user!

  def admirers
    get_user
    unless @user.blank?
      @report = Report::AdmirerReport.new
      @report.user_admirers_count @user
      render 'reports/admirer', :status => 200
    end
  end
end