class RequestsController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :admirers]
  before_action :set_request, only: [:edit, :update, :destroy]
  before_action :get_wishlist
  respond_to :html, :json

  def index
    get_user
    increment_view_count
    @following = @user.requests.unanswered.where(:wishlist_id => @wishlist.id)
    @admirers = @user.admirers.where(:wishlist_id => @wishlist.id)
    @conversations = @user.requests.answered.where(:wishlist_id => @wishlist.id)
  end

  def like
    @liked = false
    get_user
    @request = Request.find_by_id(params[:id])

    if current_user.present? && @request.present? && current_user.can_like?(@request)
      @request.request_stats.create(user: current_user, type: 'Like')
      @notification = Notification.create!(:recipient => @request.from_user, :sender => current_user, :message => "#Likes your request for your hero #{@request.to_user.name}", :read => false)
      @liked = true
    end
  end

  def help
    @helped = false
    get_user
    @request = Request.find_by_id(params[:id])

    if current_user.present? && @request.present? && current_user.can_help?(@request)
      @request.request_stats.create(user: current_user, type: 'Help')
      @notification = Notification.create!(:recipient => @request.from_user, :sender => current_user, :message => "#CanHelp fulfil your request for your hero #{@request.to_user.name}", :read => false)
      @helped = true
    end
  end

  def admirers
    get_user
    @following = @user.requests.unanswered.where(:wishlist_id => @wishlist.id)
    @admirers =  @user.admirers.where(:wishlist_id => @wishlist.id)
    @conversations = @user.requests.answered.where(:wishlist_id => @wishlist.id)
    @report = Report::AdmirerReport.new
    @report.user_admirers_count @user
  end

  def conversations
    get_user
    @following = @user.requests.unanswered.where(:wishlist_id => @wishlist.id)
    @admirers =  @user.admirers.where(:wishlist_id => @wishlist.id)
    @conversations = @user.requests.answered.where(:wishlist_id => @wishlist.id)
  end


  def add_to_my_list

    @requests = current_user.requests.unanswered.where(:wishlist_id => @wishlist.id)

    if @requests.count < @wishlist.max_count
      @user = User.find_by_twitter(params[:twitter])
      if @user.present?
        if current_user == @user
          flash[:error] = 'We are sorry, but you are being self obsessed? :)'
        else
          @request = Request.where(:from => current_user.id, :to => @user.id).first_or_initialize
          if @request.new_record?
            @request.status = false
            @request.wishlist = Wishlist.first
            if @request.save
              render 'requests/add_to_my_list'
            end
          else
            flash[:warning] = "#{@user.name} is already added to your list"
          end
        end
      else
        flash[:error] = 'Sorry!! We did not find the person you were looking for. How did you manage that :)'
      end
    else
      flash[:error] = 'Cannot add more, the list has reached its max limit'
    end

  end

  def create

    @requests = current_user.requests.unanswered.where(:wishlist_id => @wishlist.id)

    if @requests.count < @wishlist.max_count
      @user = User.where(provider: 'twitter', uid: params[:id]).first_or_initialize
      @user.name = params[:name]
      @user.image = params[:profile_image_url]
      @user.twitter = params[:screen_name]
      @user.description = params[:description]
      @user.twitter_verified = params[:verified]
      @user.location = params[:location]

      if @user.changed? || @user.new_record?
        #this is to make sure that if a user changes the any of the above information on twitter, we should update the details locally as well
        @user.save!
      end

      if current_user == @user
        flash[:error] = 'You are being self obsessed! :)'
      else
        @request = Request.where(:from => current_user.id, :to => @user.id).first_or_initialize
        if @request.new_record?
          @request.status = false
          @request.wishlist = Wishlist.first
          if @request.save
            render 'requests/create'
          end
        else
          @request = nil
          flash[:warning] = "#{@user.name} is already added to your list"
        end
      end
    else
      @request = nil
      flash[:error] = 'Cannot add more, the list has reached its max limit'
    end

  end

  def update
    @user = @request.from_user
    params[:request][:reply] = params[:request][:reply].blank? ? params[:commit] : "##{params[:commit]} #{params[:request][:reply]}"

    if @request.update(request_params)
      if params[:request][:published]
        @notification_user, @notification_message = @request.to_user, "#{@request.story} #{@request.emotion}"
      elsif @request.reply.present?
        @notification_user, @notification_message = @request.from_user, "says #{@request.reply}"
      end
      @notification = Notification.create!(:recipient => @notification_user, :sender => current_user, :message => @notification_message, :read => false) unless @notification_user.blank?
      respond_to do |f|
        f.json {render :json => @request}
        f.js { render 'update'}
      end
    end
  end

  def destroy
    @user_id = @request.to
    if @request && @request.destroy
      render 'requests/destroy'
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_request
    get_user
    @request = @user.requests.find_by_id(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def request_params
    params[:request].permit(:story, :emotion, :met_before, :published, :reply)
  end

  def increment_view_count
    referer_req = Request.find_by_id(params[:referer])

    if current_user.present? && current_user != @user && referer_req && referer_req.from_user != current_user
      req_stat = referer_req.request_stats.find_or_initialize_by(user: current_user, type: 'View')
      req_stat.save! if req_stat.new_record?
    end
  end

end
