json.array!(@subjects_teachers) do |subjects_teacher|
  json.extract! subjects_teacher, :id
  json.url subjects_teacher_url(subjects_teacher, format: :json)
end
