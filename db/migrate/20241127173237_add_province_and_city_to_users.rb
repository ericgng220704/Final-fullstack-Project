class AddProvinceAndCityToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :province, :string
    add_column :users, :city, :string
  end
end
