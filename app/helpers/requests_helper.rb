module RequestsHelper
  def tag_class(tag)
    p "tag is => #{tag}"
    "btn-#{Request::Tags[tag]}"
  end
end
