ActiveAdmin.register Product do
  permit_params :name, :short_description, :description, :price, :stock_quantity, :other_color, :designer_id, :category_id, :depth, :height, :width

  filter :name
  filter :price
  filter :stock_quantity
  filter :category, as: :select, collection: -> { Category.all.map { |c| [c.name, c.id] } }

  form do |f|
    f.inputs do
      f.input :name
      f.input :short_description
      f.input :description
      f.input :image_path
      f.input :price
      f.input :stock_quantity
      f.input :other_color
      f.input :designer
      f.input :category
      f.input :depth
      f.input :height
      f.input :width
    end
    f.actions
  end
end
