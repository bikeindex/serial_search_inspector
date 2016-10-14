require 'rails_helper'

RSpec.describe Bike, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:bike_index_id) }
    it { should validate_uniqueness_of(:bike_index_id) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:serial_search) }
  end
end
