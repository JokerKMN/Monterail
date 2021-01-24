class TicketType < ApplicationRecord
  before_create :assign_quantity_left
  belongs_to :event

  enum selling_option: { event: 0, all_together: 1, avoid_one: 2 }

  private

  def assign_quantity_left
    self.quantity_left = quantity_total
  end
end
