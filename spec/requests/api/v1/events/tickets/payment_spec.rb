# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Events::Tickets::Payment, type: :request do
  describe 'POST /api/v1/events/tickets/payment/:reservation_id' do
    subject(:pay_for_tickets) do
      post "/api/v1/events/tickets/payment/#{reservation_id}"
      response
    end

    let(:response_body) do
      JSON.parse(pay_for_tickets.body)
    end

    context 'when reservation with provided id exists' do
      let(:reservation) { create(:reservation) }
      let(:reservation_id) { reservation.id }
      let(:ticket_type) { create(:ticket_type, event_id: reservation.event_id) }

      before { create_list(:ticket, 2, reservation_id: reservation.id, ticket_type_id: ticket_type.id) }

      it { expect(pay_for_tickets).to have_http_status(:created) }

      it 'returns paid reservation data' do
        expect(response_body.with_indifferent_access).to include(
          event_id: reservation.event_id,
          status: 'paid',
          total_price: reservation.total_price
        )
      end
    end

    context 'when reservation with provided id does not exist' do
      let(:reservation_id) { 0 }

      it { expect(pay_for_tickets).to have_http_status(:not_found) }
    end
  end
end
