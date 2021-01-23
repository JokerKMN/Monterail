require 'rails_helper'

RSpec.describe Event, type: :model do
  it { expect { create(:event) }.not_to raise_error }

  context 'without required fields' do
    context 'without name' do
      it { expect { create(:event, name: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without date' do
      it { expect { create(:event, date: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end

    context 'without time' do
      it { expect { create(:event, time: nil) }.to raise_error(ActiveRecord::NotNullViolation) }
    end
  end
end
