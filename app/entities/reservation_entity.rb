class ReservationEntity < BaseEntity
  expose :status
  expose :event_id
  expose :created_at
  expose :tickets, using: TicketEntity
end
