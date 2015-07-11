module ApplicationHelper
  def display_time(time)
    if time >= Time.now - 24.hours
      "#{distance_of_time_in_words(Time.now, time)} ago"
    else
      time.strftime('%d %b  %Y at %I:%M%p')
    end

  end

  def twitter_url(user)
    "https://twitter.com/#{user.twitter}"
  end

  def req_logo
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    devise_mapping.to
  end
end
