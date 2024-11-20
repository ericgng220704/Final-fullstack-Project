class Product < ApplicationRecord
  belongs_to :category
  belongs_to :designer
  has_many :order_items

  # Allow Ransack to search specific associations
  def self.ransackable_associations(auth_object = nil)
    %w[category designer order_items]
  end

  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[id name short_description description price stock_quantity category_id depth height width created_at updated_at]
  end
end
