# frozen_string_literal: true

class Reservation < ApplicationRecord
  has_many :tickets, dependent: :destroy
  belongs_to :event

  enum status: { reserved: 0, paid: 1, canceled: 2 }

  def total_price
    tickets.map(:price).sum
  end
end
