# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CancelReservationJob, type: :job do
  let(:reservation) { create(:reservation) }
  let(:ticket_type) { create(:ticket_type, event_id: reservation.event_id) }

  before { create(:ticket, reservation_id: reservation.id, ticket_type_id: ticket_type.id) }

  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    expect { described_class.set(wait: 15.minutes).perform_later(reservation.id) }.to have_enqueued_job
  end

  it 'changes reservation status' do
    described_class.perform_now(reservation.id)

    expect(Reservation.find(reservation.id).status).to eq 'canceled'
  end

  it 'adds quantity_left to ticket_type' do
    expect { described_class.perform_now(reservation.id) }.to change { TicketType.find(ticket_type.id).quantity_left }.by(1)
  end
end
