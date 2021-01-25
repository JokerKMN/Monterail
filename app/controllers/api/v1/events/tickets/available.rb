# frozen_string_literal: true

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

            return not_found unless event

            ticket_types = event.ticket_types.available
            present(:tickets, ticket_types, with: ::TicketTypeEntity)
          end
        end
      end
    end
  end
end
