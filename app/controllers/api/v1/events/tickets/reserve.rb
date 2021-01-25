# frozen_string_literal: true

module API
  module V1
    module Events
      module Tickets
        class Reserve < Grape::API
          params do
            requires :tickets, type: Array do
              requires :id, type: Integer
              requires :quantity, type: Integer
            end
          end

          post '/reserve' do
            reservation = ::Events::Tickets::ReserveService.new.call(declared(params))

            if reservation.success?
              reservation = Reservation.includes(:tickets).find(reservation.success[:reservation_id])
              present(reservation, with: ::ReservationEntity)
            else
              status 422
              present(:message, reservation.failure[:message])
            end
          end
        end
      end
    end
  end
end
