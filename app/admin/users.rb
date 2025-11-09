ActiveAdmin.register User do
  permit_params :email, :name, :admin, :created_at, :updated_at
  
  index do
    selectable_column
    id_column
    column :email
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :email
      row :created_at
      row :updated_at
      row :last_sign_in_at
      row :sign_in_count
    end
    active_admin_comments
  end

  filter :email
  filter :admin
  filter :created_at
end
