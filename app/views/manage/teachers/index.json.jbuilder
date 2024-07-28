json.array!(@teachers) do |teacher|
  json.extract! teacher, :id
  json.url subscription_url(teacher, format: :json)
end
