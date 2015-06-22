module ApplicationHelper
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
