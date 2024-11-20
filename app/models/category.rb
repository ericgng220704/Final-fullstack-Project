class Category < ApplicationRecord
  has_many :products

  # Allow Ransack to search specific associations
  def self.ransackable_associations(auth_object = nil)
    %w[products]
  end

  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at updated_at]
  end
end
