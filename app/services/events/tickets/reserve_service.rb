# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module Events
  module Tickets
    class ReserveService
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:call)

      def call(params)
        ticket_types = yield find_ticket_type(params)
        event = yield validate_event(ticket_types[:ticket_types])
        values = yield validate_selling_options(ticket_types[:ticket_types], ticket_types[:params])
        reservation_id = yield reserve(values, event)

        Success(reservation_id)
      end

      def find_ticket_type(params)
        ticket_types = TicketType.where(id: params[:tickets].pluck(:id))
        return Failure(message: 'There are no tickets with provided ids.') unless ticket_types.any?

        Success(ticket_types: ticket_types, params: params)
      end

      def validate_event(ticket_types)
        event_ids = ticket_types.map(&:event_id).uniq

        return Failure(message: 'You can make reservation only for one event.') if event_ids.size > 1

        Success(event_ids.first)
      end

      def validate_selling_options(ticket_types, params)
        validation_errors = []
        values = []
        params[:tickets].each do |ticket|
          ticket_type = ticket_types.find(ticket[:id])

          error = validate_ticket_type_selling_option(ticket, ticket_type)
          validation_errors << error if error
          values << { ticket_type: ticket_type, quantity: ticket[:quantity] }
        end
        return Failure(message: validation_errors.join(' ')) if validation_errors.any?

        Success(values)
      end

      def reserve(values, event_id)
        reservation = Reservation.create!(
          status: 0,
          event_id: event_id
        )
        create_tickets(values, reservation)
        cancel_unpaid_reservation(reservation.id)
        Success(reservation_id: reservation.id)
      end

      private

      attr_reader :params

      def validate_ticket_type_selling_option(ticket, ticket_type)
        case ticket_type.selling_option
        when 'even'
          return "Tickets quantity must be even for #{ticket_type.name}." if ticket[:quantity].odd?
        when 'all_together'
          return "You must buy all tickets for #{ticket_type.name}." if ticket[:quantity] != ticket_type.quantity_total
        when 'avoid_one'
          return "You cannot leave one ticket for #{ticket_type.name}." if ticket_type.quantity_left - ticket[:quantity] == 1
        end

        quantity_left = (ticket_type.quantity_left - ticket[:quantity])
        return "Tickets quantity is bigger than quantity of available tickets for for #{ticket_type.name}" if quantity_left.negative?
      end

      def create_tickets(values, reservation)
        values.each do |value|
          ticket_type = value[:ticket_type]
          quantity = value[:quantity]
          ticket_type.update!(quantity_left: (ticket_type.quantity_left - quantity))
          quantity.times do
            Ticket.create!(
              name: ticket_type.name,
              ticket_type_id: ticket_type.id,
              reservation_id: reservation.id
            )
          end
        end
      end

      def cancel_unpaid_reservation(reservation_id)
        CancelReservationJob.set(wait: 15.minutes).perform_later(reservation_id)
      end
    end
  end
end
