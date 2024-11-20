class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.text :short_description
      t.text :description
      t.decimal :price
      t.integer :stock_quantity
      t.boolean :other_color
      t.integer :designer_id
      t.integer :category_id
      t.integer :depth
      t.integer :height
      t.integer :width

      t.timestamps
    end
  end
end
