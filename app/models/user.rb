class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :orders

  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[id first_name last_name email phone_number address created_at updated_at]
  end

  # Allow Ransack to search specific associations
  def self.ransackable_associations(auth_object = nil)
    %w[orders]
  end

  # Validations
  validates :address, presence: true
  validates :phone_number, presence: true
end
