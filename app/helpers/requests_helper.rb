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
end
