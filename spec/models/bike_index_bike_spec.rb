require 'rails_helper'

RSpec.describe BikeIndexBike, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:stolen) }
    it { should validate_presence_of(:bike_index_id) }
    it { should validate_presence_of(:serial_search_id) }
    it { should validate_uniqueness_of(:bike_index_id) }
    it { should validate_uniqueness_of(:serial_search_id) }
  end

  describe 'associations' do
    it { should belong_to(:serial_search) }
  end
end
