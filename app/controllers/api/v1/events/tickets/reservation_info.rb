# frozen_string_literal: true

module API
  module V1
    module Events
      module Tickets
        class ReservationInfo < Grape::API
          params do
            requires :id, type: Integer
          end

          get '/reservation/:id' do
            reservation = Reservation.find_by(id: declared(params)[:id])

            return not_found unless reservation

            present(reservation, with: ::ReservationEntity)
          end
        end
      end
    end
  end
end
