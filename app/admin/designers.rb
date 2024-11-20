ActiveAdmin.register Designer do
  permit_params :name

  # Customize how the categories are displayed
  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  # Form for creating/editing a category
  form do |f|
    f.inputs do
      f.input :name
    end
    f.actions
  end

end
