require 'rails_helper'

RSpec.describe SerialSearch, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:serial) }
    it { should validate_presence_of(:searched_bike_index_at) }
    it { should validate_uniqueness_of(:serial) }
  end

  describe 'associations' do
    it { should have_many(:log_lines) }
    it { should have_many(:ip_addresses) }
    it { should have_many(:bike_index_bikes) }
  end
end
