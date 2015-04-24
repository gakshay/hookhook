class RequestsController < ApplicationController

  before_action :set_request, only: [:edit, :update, :destroy]

  def create

    @wishlist = Wishlist.first
    @requests = current_user.requests.where(:wishlist_id => @wishlist.id)

    if @requests.count < @wishlist.max_count
      @user = User.where(provider: 'twitter', uid: params[:id]).first_or_create do |user|
        user.name = params[:name]
        user.image = params[:profile_image_url]
        user.twitter = params[:screen_name]
        user.description = params[:description]
        user.twitter_verified = params[:verified]
      end
      unless current_user == @user
        if @user.persisted?
          @request = Request.where(:from => current_user.id, :to => @user.id).first_or_initialize
          if @request.new_record?
            @request.status = false
            @request.wishlist = Wishlist.first
            if @request.save
              render 'requests/create'
            end
          else
            flash[:warning] = "#{@user.name} is already added to your list"
          end
        end
      else
        flash[:error] = 'You cannot add yourself'
      end
    else
      flash[:error] = 'Cannot add more, the list has reached its max limit'
    end

  end

  def update
    @user = @request.from_user
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Your story is saved.' }
        format.js
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.js { render js: "alert('Experiencing techinical issues saving your story')"}
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user_id = @request.to_user.id
    if @request && @request.delete
      render 'requests/destroy'
    else
      format.json { render :json => 'User does not exist', :status => 400 }
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = current_user.requests.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params[:request].permit(:story, :pitch_list)
  end
end
