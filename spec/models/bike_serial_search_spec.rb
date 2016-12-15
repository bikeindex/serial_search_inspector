require 'rails_helper'

RSpec.describe BikeSerialSearch, type: :model do
  describe 'associations' do
    it { should belong_to(:bike) }
    it { should belong_to(:serial_search) }
  end
end
