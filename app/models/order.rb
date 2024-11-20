class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items

  # Allow Ransack to search specific associations
  def self.ransackable_associations(auth_object = nil)
    %w[user order_items]
  end

  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[status order_date total_amount created_at updated_at]
  end
end
