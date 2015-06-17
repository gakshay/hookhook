module RequestsHelper
  def tag_class(tag)
    "btn-#{Request::Tags[tag]}"
  end

  def hash_tags(tags)
    tags.map{|tag| "##{tag}"}.join(' ')
  end
end
