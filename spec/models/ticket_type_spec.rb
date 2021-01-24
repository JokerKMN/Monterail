require 'rails_helper'

RSpec.describe TicketType, type: :model do
  it { expect { create(:ticket_type) }.not_to raise_error }

  context 'without required fields' do
    context 'without name' do
      it { expect { create(:ticket_type, name: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without price' do
      it { expect { create(:ticket_type, price: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without currency' do
      it { expect(create(:ticket_type).currency).to eq('EUR') }
    end

    context 'without quantity_total' do
      it { expect { create(:ticket_type, quantity_total: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without quantity_left' do
      let(:ticket_type) { create(:ticket_type, quantity_left: nil) }

      it 'assigns quantity_left' do
        expect(ticket_type.quantity_left).to eq(ticket_type.quantity_total)
      end
    end

    context 'without selling_option' do
      it { expect { create(:ticket_type, selling_option: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without event' do
      it { expect { create(:ticket_type, event: nil) }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
