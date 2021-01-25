# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Events::Tickets::ReservationInfo, type: :request do
  describe 'GET /api/v1/events/tickets/reservation/:id' do
    subject(:reservation_info) do
      get "/api/v1/events/tickets/reservation/#{id}"
      response
    end

    let(:response_body) do
      JSON.parse(reservation_info.body)
    end

    context 'with valid params types' do
      let(:reservation) { create(:reservation) }
      let(:id) { reservation.id }

      it 'returns reservation entity' do
        expect(response_body.with_indifferent_access).to include(
          event_id: reservation.event_id,
          status: 'reserved'
        )
      end
    end

    context 'with invalid params types' do
      let(:id) { 0 }

      it { expect(reservation_info).to have_http_status(:not_found) }
    end
  end
end
