class HomeController < ApplicationController

  def index
    
  end

  def load_suggestions
    @suggestions = User.select(:name) #Select the data you want to load on the typeahead.
    render json: @suggestions
  end

end
