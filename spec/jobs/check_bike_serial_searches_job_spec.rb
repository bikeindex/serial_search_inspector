require 'rails_helper'

RSpec.describe CheckBikeSerialSearchesJob, type: :job do
  describe 'perform' do
    let(:serial_search) { FactoryGirl.create(:serial_search) }
    let!(:bike) { FactoryGirl.create(:bike, serial: serial_search.serial) }

    it 'creates a bike_serial_search record and its associations' do
      ActiveJob::Base.queue_adapter = :inline
      CheckBikeSerialSearchesJob.perform_later(bike, serial_search.serial)

      expect(BikeSerialSearch.count).to eq(1)
      expect(serial_search.bikes.first).to eq(bike)
      expect(bike.serial_searches.first).to eq(serial_search)
    end
  end
end
