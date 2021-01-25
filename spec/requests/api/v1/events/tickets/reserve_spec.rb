require 'rails_helper'

RSpec.describe API::V1::Events::Tickets::Reserve, type: :request do
  describe 'POST /api/v1/events/tickets/reserve' do
    subject(:reserve_tickets) do
      post '/api/v1/events/tickets/reserve', params: params
      response
    end

    let(:response_body) do
      JSON.parse(reserve_tickets.body)
    end

    context 'with valid param types' do
      RSpec.shared_examples 'reservation entity response' do
        it 'returns reservation entity' do
          expect(response_body.with_indifferent_access).to include(
            event_id: ticket_type.event_id,
            status: 'reserved'
          )
        end

        it 'returns list of tickets' do
          expect(response_body['tickets'].size).to eq(10)
        end
      end

      let(:params) do
        { tickets: [
          { id: ticket_type.id,
            quantity: quantity }
        ] }
      end

      context 'when tickets have even selling_option' do
        let(:ticket_type) { create(:ticket_type, quantity_total: 10) }

        context 'with valid selling_option' do
          let(:quantity) { 10 }

          it { expect(reserve_tickets).to have_http_status(:created) }

          it_behaves_like 'reservation entity response'
        end

        context 'with invalid selling_option' do
          context 'with quantity that does not apply to selling option' do
            let(:quantity) { 7 }

            it { expect(reserve_tickets).to have_http_status(:unprocessable_entity) }
            it { expect(response_body['message']).to eq("Tickets quantity must be even for #{ticket_type.name}.") }
          end
        end
      end

      context 'when tickets have avoid_one selling_option' do
        let(:ticket_type) { create(:ticket_type, quantity_total: 10, selling_option: 'avoid_one') }

        context 'with valid selling_option' do
          let(:quantity) { 10 }

          it { expect(reserve_tickets).to have_http_status(:created) }

          it_behaves_like 'reservation entity response'
        end

        context 'with invalid selling_option' do
          context 'with quantity that does not apply to selling option' do
            let(:quantity) { 9 }

            it { expect(reserve_tickets).to have_http_status(:unprocessable_entity) }
            it { expect(response_body['message']).to eq("You cannot leave one ticket for #{ticket_type.name}.") }
          end
        end
      end

      context 'when tickets have all_together selling_options' do
        let(:ticket_type) { create(:ticket_type, quantity_total: 10, selling_option: 'all_together') }

        context 'with valid selling_option' do
          let(:quantity) { 10 }

          it { expect(reserve_tickets).to have_http_status(:created) }

          it_behaves_like 'reservation entity response'
        end

        context 'with invalid selling_option' do
          context 'with quantity that does not apply to selling option' do
            let(:quantity) { 9 }

            it { expect(reserve_tickets).to have_http_status(:unprocessable_entity) }
            it { expect(response_body['message']).to eq("You must buy all tickets for #{ticket_type.name}.") }
          end
        end
      end
    end

    context 'with invalid params types' do
      let(:params) { nil }

      it { expect(reserve_tickets).to have_http_status(:bad_request) }
    end
  end
end
