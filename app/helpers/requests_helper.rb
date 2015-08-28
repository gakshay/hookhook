module RequestsHelper
  def tag_class(tag)
    "btn-#{Request::Tags[tag]}"
  end

  def hash_tags(tags)
    tags.map{|tag| "##{tag}"}.join(' ')
  end

  def replier(req)
    current_user == req.to_user ? 'you' : req.to_user.name
  end

  def visible?(request)
    request.public? || current_user == request.to_user || current_user == request.from_user
  end

end
