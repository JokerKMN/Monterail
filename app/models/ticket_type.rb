class TicketType < ApplicationRecord
  before_create :assign_quantity_left
  belongs_to :event
  has_many :tickets, dependent: :destroy

  enum selling_option: { even: 0, all_together: 1, avoid_one: 2 }

  scope :available, -> { where('quantity_left > ?', 0) }

  private

  def assign_quantity_left
    self.quantity_left = quantity_total
  end
end
