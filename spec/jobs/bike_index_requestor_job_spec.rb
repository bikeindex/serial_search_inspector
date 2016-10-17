require 'rails_helper'

RSpec.describe BikeIndexRequestorJob, type: :job do
  describe 'perform' do
    context 'new record' do
      it 'creates a new bike and associates with serial_search' do
        VCR.use_cassette('bike_index_requestor_job') do
          ActiveJob::Base.queue_adapter = :inline
          serial_search = SerialSearch.find_or_create_by(serial: 'Y524347') #
          BikeIndexRequestorJob.perform_later(serial_search)
          bike = Bike.last
          serial_search.reload
          expect(bike.stolen).to be_falsey
          expect(bike.bike_index_id).to eq 30569
          expect(bike.serial_searches).to eq([serial_search])
          expect(serial_search.searched_bike_index_at).to be_within(1.second).of Time.now
        end
      end
      context 'within 8 hours' do
        it 'does not search bike index' do
          serial_search = FactoryGirl.create(:serial_search, searched_bike_index_at: DateTime.now)
          ActiveJob::Base.queue_adapter = :inline
          expect(Bike).to receive(:find_or_create_bikes_from_bike_array).exactly(0).times
          BikeIndexRequestorJob.perform_later(serial_search)
        end
      end
    end
  end
end
