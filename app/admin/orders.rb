ActiveAdmin.register Order do
  permit_params :status, :order_date, :total_amount, :user_id

  # Filters
  filter :status
  filter :order_date
  filter :total_amount
  filter :user, as: :select, collection: -> { User.all.map { |u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id] } }

  index do
    selectable_column
    id_column
    column :status
    column :order_date
    column :total_amount
    column :tax_rate
    column :user
    actions
  end

  form do |f|
    f.inputs do
      f.input :status
      f.input :order_date, as: :date_picker
      f.input :total_amount
      f.input :tax_rate
      f.input :user, as: :select, collection: User.all.map { |u| ["#{u.first_name} #{u.last_name} (#{u.email})", u.id] }
    end
    f.actions
  end
end
