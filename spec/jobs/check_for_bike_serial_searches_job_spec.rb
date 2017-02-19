require 'rails_helper'

RSpec.describe CheckForBikeSerialSearchesJob, type: :job do
  describe 'perform' do
    let(:serial_search) { FactoryGirl.create(:serial_search) }
    let!(:bike) { FactoryGirl.create(:bike, serial: serial_search.serial) }

    it 'creates a bike_serial_search record' do
      ActiveJob::Base.queue_adapter = :inline
      CheckForBikeSerialSearchesJob.perform_later(serial_search.serial)

      expect(bike.serial_searches.first).to eq(serial_search)
      expect(serial_search.bikes.first).to eq(bike)
    end
  end
end
