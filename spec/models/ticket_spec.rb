require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it { expect { create(:ticket) }.not_to raise_error }

  context 'without required fields' do
    context 'without name' do
      it { expect { create(:ticket, name: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without ticket_type' do
      it { expect { create(:ticket, ticket_type: nil) }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
