class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def render_404(value)
    respond_to do |format|
      format.html { redirect_to root_url, error: "#{value} was not found", :status => 404 }
      format.json { render :json => {error: "#{value} not found"}, :status => 404 }
    end

  end
end
