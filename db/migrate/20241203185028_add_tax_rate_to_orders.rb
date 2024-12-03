class AddTaxRateToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :tax_rate, :decimal
  end
end
