# frozen_string_literal: true

class CancelReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.includes(:tickets).find(reservation_id)

    return unless reservation.reserved?

    reservation.canceled!

    ticket_types = reservation.tickets.group(:id).count
    ticket_types.each do |tt|
      ticket_type = TicketType.find(tt.first)
      ticket_type.quantity_left += tt.second
      ticket_type.save!
    end
  end
end
