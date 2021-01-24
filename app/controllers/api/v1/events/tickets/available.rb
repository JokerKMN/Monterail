module API
  module V1
    module Events
      module Tickets
        class Available < Grape::API
          params do
            requires :id, type: Integer
          end

          get '/available' do
            event_id = declared(params)[:id]
            event = Event.find_by(id: event_id)
            if event
              ticket_types = event.ticket_types.available
              present(:tickets, ticket_types, with: ::TicketTypeEntity)
            else
              status 404
              present(:message, "Couldn't find Event with id #{event_id}.")
            end
          end
        end
      end
    end
  end
end
