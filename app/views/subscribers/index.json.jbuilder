json.array!(@subscribers) do |subscriber|
  json.extract! subscriber, :id
  json.url subscriber_url(subscriber, format: :json)
end
