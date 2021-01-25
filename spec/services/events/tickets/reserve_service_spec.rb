require 'rails_helper'

RSpec.describe Events::Tickets::ReserveService do
  describe '#call' do
    subject(:reserve_tickets) { described_class.new.call(params) }

    context 'with valid params' do
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

          it 'creates tickets' do
            expect { reserve_tickets }.to change { Ticket.all.size }.by(10)
          end

          it 'creates reservation' do
            expect { reserve_tickets }.to change { Reservation.all.size }.by(1)
          end

          it 'returns reservation_id' do
            expect(reserve_tickets.success[:reservation_id]).to eq(Reservation.last.id)
          end
        end
      end
    end

    context 'with invalid params' do
      let(:ticket_type) { create(:ticket_type, quantity_total: 10, selling_option: selling_option) }
      let(:selling_option) { 'even' }

      context 'when ticket_type with provided id does not exist' do
        let(:params) do
          { tickets: [
            { id: 0,
              quantity: 10 }
          ] }
        end

        it { expect(reserve_tickets).to be_failure }

        it { expect(reserve_tickets.failure[:message]).to eq('There are no tickets with provided ids.') }
      end

      context 'when ticket_types belongs to different events' do
        let(:params) do
          { tickets: [
            { id: ticket_type.id,
              quantity: 10 },
            { id: ticket_type2.id,
              quantity: 10 }
          ] }
        end
        let(:ticket_type2) { create(:ticket_type, quantity_total: 10) }

        it { expect(reserve_tickets).to be_failure }

        it { expect(reserve_tickets.failure[:message]).to eq('You can make reservation only for one event.') }
      end

      context 'when quantity_left is lower than quantity of tickets' do
        let(:params) do
          { tickets: [
            { id: ticket_type.id,
              quantity: quantity }
          ] }
        end
        let(:quantity) { ticket_type.quantity_total + 2 }

        it { expect(reserve_tickets).to be_failure }

        it {
          expect(reserve_tickets.failure[:message]).to eq("Tickets quantity is bigger than quantity of available tickets for for #{ticket_type.name}")
        }
      end

      context 'when selling options are invalid' do
        let(:params) do
          { tickets: [
            { id: ticket_type.id,
              quantity: quantity }
          ] }
        end

        context 'when there is event selling option' do
          let(:quantity) { 7 }

          it { expect(reserve_tickets).to be_failure }

          it { expect(reserve_tickets.failure[:message]).to eq("Tickets quantity must be even for #{ticket_type.name}.") }
        end

        context 'when there is all_together selling option' do
          let(:quantity) { 7 }
          let(:selling_option) { 'all_together' }

          it { expect(reserve_tickets).to be_failure }

          it { expect(reserve_tickets.failure[:message]).to eq("You must buy all tickets for #{ticket_type.name}.") }
        end

        context 'when there is avoid_one selling option' do
          let(:quantity) { 9 }
          let(:selling_option) { 'avoid_one' }

          it { expect(reserve_tickets).to be_failure }

          it { expect(reserve_tickets.failure[:message]).to eq("You cannot leave one ticket for #{ticket_type.name}.") }
        end

        context 'when all selling options failed' do
          let(:params) do
            { tickets: [
              { id: even_tt.id,
                quantity: 7 },
              { id: all_together_tt.id,
                quantity: 9 },
              { id: avoid_one_tt.id,
                quantity: 9 }
            ] }
          end
          let(:event) { create(:event) }
          let(:even_tt) { create(:ticket_type, quantity_total: 10, selling_option: 'even', event: event) }
          let(:all_together_tt) { create(:ticket_type, quantity_total: 10, selling_option: 'all_together', event: event) }
          let(:avoid_one_tt) { create(:ticket_type, quantity_total: 10, selling_option: 'avoid_one', event: event) }

          it { expect(reserve_tickets).to be_failure }

          it {
            expect(reserve_tickets.failure[:message]).to eq("Tickets quantity must be even for #{even_tt.name}" \
            ". You must buy all tickets for #{all_together_tt.name}." \
            " You cannot leave one ticket for #{avoid_one_tt.name}.")
          }
        end
      end
    end
  end
end
