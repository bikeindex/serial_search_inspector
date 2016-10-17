require 'rails_helper'

RSpec.describe Bike, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:bike_index_id) }
    it { should validate_uniqueness_of(:bike_index_id) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:serial_searches) }
  end

  describe 'find_or_create_bikes_from_bike_array' do
    context 'new bike' do
      let(:serial_search) { FactoryGirl.create(:serial_search) }
      let(:bike_array) { [{ serial_search_id: serial_search.id, bike_index_id: 30080, stolen: false, date_stolen: nil }] }
      it 'creates a new bike entry and associates' do
        Bike.find_or_create_bikes_from_bike_array(bike_array)
        expect(Bike.first.serial_searches.first).to eq serial_search
        expect(serial_search.bikes.first).to eq Bike.first
      end
    end
    context 'bike already exists' do
      let(:serial_search_1) { FactoryGirl.create(:serial_search) }
      let(:serial_search_2) { FactoryGirl.create(:serial_search) }
      let(:bike_array_1) { [{ serial_search_id: serial_search_1.id, bike_index_id: 30080, stolen: false, date_stolen: nil }] }
      let(:bike_array_2) { [{ serial_search_id: serial_search_2.id, bike_index_id: 30080, stolen: false, date_stolen: nil }] }
      it 'associates with serial_search' do
        Bike.find_or_create_bikes_from_bike_array(bike_array_1)
        Bike.find_or_create_bikes_from_bike_array(bike_array_2)
        Bike.find_or_create_bikes_from_bike_array(bike_array_1)
        bike = Bike.first
        expect(Bike.count).to eq 1
        expect(bike.serial_searches.count).to eq 2
        expect(bike.serial_searches).to include(serial_search_1)
        expect(bike.serial_searches).to include(serial_search_2)
      end
    end
  end

  describe 'update_was_stolen' do
    context 'not stolen' do
      it 'does not change was_stolen' do
        bike = Bike.new(bike_index_id: 30080, stolen: false, date_stolen: nil)
        bike.update_was_stolen
        expect(bike.was_stolen).to be_falsey
      end
    end
    context 'stolen' do
      it 'changes was_stolen to true' do
        bike = Bike.new(bike_index_id: 30080, stolen: true, date_stolen: 1400565600)
        bike.update_was_stolen
        expect(bike.was_stolen).to be_truthy
      end
    end
    context 'stolen and later recovered' do
      it 'does not reset was_stolen' do
        bike = Bike.new(bike_index_id: 30080, stolen: true, date_stolen: 1400565600)
        bike.update_was_stolen
        bike.stolen = false
        expect(bike.stolen).to be_falsey
        expect(bike.was_stolen).to be_truthy
      end
    end
  end
end
