class ReportsController < ApplicationController
  # before_action :authenticate_user!

  def admirer
    @report = Report::AdmirerReport.new
    @report.user_admirers_count current_user
    render 'reports/admirer', :status => 200
  end
end