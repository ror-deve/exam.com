ActiveAdmin.register Exam do
  permit_params :account_id , :name , :status ,:duration , :start_time , :end_time , :batch_id
end
