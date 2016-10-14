require 'rails_helper'

RSpec.describe BikeIndexRequestorJob, type: :job do
  describe 'perform' do
    it 'creates a new bike and associates with serial_search' do
      VCR.use_cassette('bike_index_requestor_job') do
        ActiveJob::Base.queue_adapter = :inline
        serial_search = SerialSearch.find_or_create_by(serial: 'Y524347') #
        BikeIndexRequestorJob.perform_later(serial_search)
        bike = Bike.last
        expect(bike.stolen).to be_falsey
        expect(bike.bike_index_id).to eq 30569
        expect(bike.serial_searches).to eq([serial_search])
      end
    end
  end
end
