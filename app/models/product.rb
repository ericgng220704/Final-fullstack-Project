class Product < ApplicationRecord
  belongs_to :category
  belongs_to :designer
  has_many :order_items
  has_one_attached :image

  # Allow Ransack to search specific associations
  def self.ransackable_associations(auth_object = nil)
    %w[category designer order_items]
  end

  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[id name short_description description price stock_quantity category_id depth height width created_at updated_at]
  end

   # Scope for new products (added within the last 3 days)
   scope :new_products, -> { where('created_at >= ?', 3.days.ago) }

   # Scope for recently updated products (updated within the last 3 days)
   scope :recently_updated, -> {
  where('updated_at >= ?', 3.days.ago)
  .where('created_at < ?', 3.days.ago)
  }


   # Scope for keyword search
   scope :search, ->(query) {
    where('products.name ILIKE :query OR short_description ILIKE :query OR description ILIKE :query', query: "%#{query}%")
  }



   # Scope for filtering by category
   scope :by_category, ->(category) {
    joins(:category).where('categories.name = ?', category) if category.present?
  }

end
