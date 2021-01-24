require 'rails_helper'

RSpec.describe Reservation, type: :model do
  it { expect { create(:reservation) }.not_to raise_error }

  context 'without required fields' do
    context 'without status' do
      it { expect { create(:reservation, status: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without event association' do
      it { expect { create(:reservation, event: nil) }.to raise_error(ActiveRecord::RecordInvalid) }
    end
  end
end
