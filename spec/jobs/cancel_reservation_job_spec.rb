require 'rails_helper'

RSpec.describe CancelReservationJob, type: :job do
  let(:reservation) { create(:reservation) }

  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    expect { described_class.set(wait: 15.minutes).perform_later(reservation.id) }.to have_enqueued_job
  end

  it 'changes reservation status' do
    described_class.perform_now(reservation.id)

    expect(Reservation.find(reservation.id).status).to eq 'canceled'
  end
end
