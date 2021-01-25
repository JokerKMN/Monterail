# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Events::Tickets::Available, type: :request do
  describe 'GET /api/v1/events/:id/tickets/available' do
    subject(:get_available_tickets) do
      get "/api/v1/events/#{event_id}/tickets/available"
      response
    end

    let(:response_body) do
      JSON.parse(get_available_tickets.body)
    end

    context 'when event with provided id exist' do
      let(:event) { create(:event) }
      let(:event_id) { event.id }

      context 'when there are available tickets' do
        before { create_list(:ticket_type, 3, event: event) }

        it { expect(get_available_tickets).to have_http_status(:ok) }

        it 'returns array of tickets' do
          expect(response_body['tickets'].size).to eq(3)
        end

        it 'returns ticket_type with data' do
          expect(response_body['tickets'].first.keys).to eq(%w[name quantity_left])
        end
      end

      context 'when there is no available tickets left' do
        before { create_list(:ticket_type, 2, quantity_left: 0) }

        it { expect(get_available_tickets).to have_http_status(:ok) }

        it 'returns empty array' do
          expect(response_body['tickets']).to eq([])
        end
      end
    end

    context 'when event with provided id does not exist' do
      let(:event_id) { 0 }

      it { expect(get_available_tickets).to have_http_status(:not_found) }

      it 'returns error message' do
        expect(response_body['message']).to eq("Couldn't find Event with id 0.")
      end
    end
  end
end
