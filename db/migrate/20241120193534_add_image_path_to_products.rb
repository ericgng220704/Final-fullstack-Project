class AddImagePathToProducts < ActiveRecord::Migration[7.2]
  def change
    add_column :products, :image_path, :string
  end
end
