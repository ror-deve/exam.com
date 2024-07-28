ActiveAdmin.register Account do
  permit_params :owner_id, :email, :phone, :address, :name
end
