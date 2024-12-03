class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :total_amount, presence: true
  validates :status, inclusion: { in: %w[unpaid paid delivering delivered canceled completed] }

  # Check if an order can be canceled
  def cancelable?
    %w[unpaid paid].include?(status)
  end

  # Check if the order can be confirmed
  def confirmable?
    status == 'delivered'
  end

  # Transition order to paid
  def mark_as_paid
    update(status: 'paid') if status == 'unpaid'
  end

  # Transition order to delivering
  def mark_as_delivering
    update(status: 'delivering') if status == 'paid'
  end

  # Transition order to delivered
  def mark_as_delivered
    update(status: 'delivered') if status == 'delivering'
  end

  # Mark order as completed
  def complete_order
    update(status: 'completed') if status == 'delivered'
  end

  # Allow Ransack to search specific associations
  def self.ransackable_associations(auth_object = nil)
    %w[user order_items]
  end

  # Allow Ransack to search specific attributes
  def self.ransackable_attributes(auth_object = nil)
    %w[status order_date total_amount tax_rate created_at updated_at]
  end
end
