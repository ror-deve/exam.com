ActiveAdmin.register Teacher do
  permit_params :name,:email,:phone, :password, :password_confirmation
  form do |f|
    f.inputs "Teacher" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
