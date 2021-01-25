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

            if reservation
              present(reservation, with: ::ReservationEntity)
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
