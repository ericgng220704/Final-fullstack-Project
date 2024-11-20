class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Allow Ransack to search specific associations (if applicable)
  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[id first_name last_name email phone_number address created_at updated_at]
  end
end
