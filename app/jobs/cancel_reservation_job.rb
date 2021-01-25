class CancelReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    reservation = Reservation.find(reservation_id)

    reservation.canceled! if reservation.reserved?
  end
end
