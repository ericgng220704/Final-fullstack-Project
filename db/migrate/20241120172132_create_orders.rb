class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :order_date
      t.string :status
      t.decimal :total_amount

      t.timestamps
    end
  end
end
