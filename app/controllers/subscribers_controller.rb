class SubscribersController < ApplicationController
  # before_action :set_subscriber, only: [:show, :edit, :update, :destroy]

  # GET /subscribers/new
  def new
    @subscriber = Subscriber.new
  end

  # POST /subscribers
  # POST /subscribers.json
  def create
    @subscriber = Subscriber.new(subscriber_params)

    respond_to do |format|
      if @subscriber.save
        format.html { redirect_to root_url,
                                  notice: 'Fantastic, looks like you are an inspired soul. See you soon' }
        format.json { render :show, status: :created, location: @subscriber }
      else
        format.html { redirect_to "/", alert: @subscriber.errors.full_messages.to_sentence }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber
      @subscriber = Subscriber.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscriber_params
      params[:subscriber].permit(:email, :twitter, :blog, :founding, :linkedin, :reason, :hero)
    end
end
