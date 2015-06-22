module ApplicationHelper
  def twitter_url(user)
    "https://twitter.com/#{user.twitter}"
  end

  def can_like?(user, req)
    user.present? && user != req.to_user && user != req.from_user && req.request_stats.where(:user => user, type: 'Like').blank?
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
