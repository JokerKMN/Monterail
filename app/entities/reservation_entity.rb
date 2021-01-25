# frozen_string_literal: true

class ReservationEntity < BaseEntity
  expose :status
  expose :event_id
  expose :created_at
  expose :total_price
  expose :tickets, using: TicketEntity
end
