class Page < ApplicationRecord
  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[title content]
  end
end
