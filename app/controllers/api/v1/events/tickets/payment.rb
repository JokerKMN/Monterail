# frozen_string_literal: true

module API
  module V1
    module Events
      module Tickets
        class Payment < Grape::API
          params do
            requires :reservation_id, type: Integer
          end

          post '/payment/:reservation_id' do
            reservation = Reservation.find_by(id: declared(params)[:reservation_id])

            if reservation
              paid_reservation = ::Events::Tickets::PaymentService.new.call(reservation)
              present(paid_reservation.success, with: ::ReservationEntity)
            else
              status 422
              present(:message, 'There is no reservation with provided id.')
            end
          end
        end
      end
    end
  end
end
