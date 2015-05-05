module RequestsHelper
  def tag_class(tag)
    "btn-#{Request::Tags[tag]}"
  end
end
