# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::Events::Show, type: :request do
  describe 'GET /api/v1/events/:id' do
    subject(:get_event) do
      get "/api/v1/events/#{event_id}"
      response
    end

    let(:response_body) do
      JSON.parse(get_event.body)
    end

    context 'with valid params' do
      context 'when event does not exist' do
        let(:event_id) { 0 }

        it { expect(get_event).to have_http_status(:not_found) }
        it { expect(response_body['message']).to eq('Requested entity not found') }
      end

      context 'when event exists' do
        let(:event) { create(:event) }
        let(:event_id) { event.id }

        it { expect(get_event).to have_http_status(:ok) }

        it 'returns information about event' do
          expect(response_body.keys).to eq(%w[name date time])
        end

        it 'returns event object in correct format' do
          expect(response_body.with_indifferent_access).to include(
            name: event.name,
            date: event.date.strftime('%Y-%m-%d'),
            time: event.time.strftime('%H:%M:%S')
          )
        end
      end
    end
  end
end
