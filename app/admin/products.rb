ActiveAdmin.register Product do
  # Add `:image` to the permitted params
  permit_params :name, :short_description, :description, :price, :stock_quantity, :other_color, :designer_id, :category_id, :depth, :height, :width, :image

  # Filters for product search
  filter :name
  filter :price
  filter :stock_quantity
  filter :category, as: :select, collection: -> { Category.all.map { |c| [c.name, c.id] } }

  # Form for creating/editing products
  form do |f|
    f.inputs do
      f.input :name
      f.input :short_description
      f.input :description
      f.input :image, as: :file
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

  # Show page to display product details
  show do
    attributes_table do
      row :name
      row :short_description
      row :description
      row :image do |product|
        if product.image.attached?
          image_tag url_for(product.image), size: "200x200"
        else
          "No Image Available"
        end
      end
      row :price
      row :stock_quantity
      row :other_color
      row :designer
      row :category
      row :depth
      row :height
      row :width
    end
  end

  # Index page to display all products
  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    column :image do |product|
      if product.image.attached?
        image_tag url_for(product.image), size: "50x50"
      else
        "No Image"
      end
    end
    actions
  end
end
