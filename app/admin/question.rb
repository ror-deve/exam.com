ActiveAdmin.register Question do
  permit_params :account_id, :topic_id, :title, :option1, :option2, :option3, :option4, :option5, :answer, :marks, :negative_marks 
end
