class CreateDesigners < ActiveRecord::Migration[7.2]
  def change
    create_table :designers do |t|
      t.string :name

      t.timestamps
    end
  end
end
