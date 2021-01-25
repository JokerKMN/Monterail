# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::Tickets::PaymentService do
  describe '#call' do
    subject(:pay_for_tickets) { described_class.new.call(reservation) }

    let(:reservation) { create(:reservation) }
    let(:ticket_type) { create(:ticket_type, event_id: reservation.event_id) }

    before { create(:ticket, reservation_id: reservation.id, ticket_type_id: ticket_type.id) }

    context 'with valid token' do
      it { expect { pay_for_tickets }.not_to raise_error }

      it 'updates reservation status' do
        expect { pay_for_tickets }.to change { reservation.reload.status }.from('reserved').to('paid')
      end

      it 'returns payment' do
        expect(pay_for_tickets.success).to be_a_kind_of(Reservation)
      end
    end

    context 'with invalid token' do
      context 'when card_error occurs' do
        before do
          allow_any_instance_of(described_class).to receive(:generate_token).and_return('card_error')
        end

        it { expect { pay_for_tickets }.to raise_error(Payment::Gateway::CardError) }
      end

      context 'when payment_error occurs' do
        before do
          allow_any_instance_of(described_class).to receive(:generate_token).and_return('payment_error')
        end

        it { expect { pay_for_tickets }.to raise_error(Payment::Gateway::PaymentError) }
      end
    end
  end
end
