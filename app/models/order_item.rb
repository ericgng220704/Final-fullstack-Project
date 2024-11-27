class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :product_id, :quantity, :price_at_purchase, presence: true
end
