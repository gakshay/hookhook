json.array!(@eligibilities) do |eligibility|
  json.extract! eligibility, :id, :designation, :explore, :interest, :priority, :meet
  json.url eligibility_url(eligibility, format: :json)
end
