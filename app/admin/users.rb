ActiveAdmin.register User do
  # Specify which attributes to display in the index table
  index do
    selectable_column
    id_column
    column :email
    column :created_at
    column :updated_at
    actions
  end

  # Configure the filters in the sidebar
  filter :email
  filter :created_at

  # Specify which attributes to show in the form
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  # Configure the permitted parameters for Active Admin
  permit_params :email, :password, :password_confirmation
end
