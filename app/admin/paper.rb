ActiveAdmin.register Paper do
  permit_params :name , :account_id ,:exam_id ,:no_of_questions, :status , :duration , :marks_per_question , :negative_marks_per_question
end
