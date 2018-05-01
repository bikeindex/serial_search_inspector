require 'rails_helper'

RSpec.describe FetchBikeByBikeIndexIdJob, type: :job do
  describe 'perform' do
    let(:bike) { FactoryBot.create(:bike, bike_index_id: 30569, serial: nil) }
    let(:binx_response) { JSON.parse(File.read(Rails.root.join('spec/fixtures/binx_bike_by_id.json'))) }

    it 'updates the bikes attributes' do
      expect_any_instance_of(BikeIndex::Requester).to receive(:request_bike_by_bike_index_id) { binx_response }

      ActiveJob::Base.queue_adapter = :inline
      FetchBikeByBikeIndexIdJob.new.perform(bike)

      expect(bike.serial).to eq('Y524347')
      expect(bike.title).to eq('Schwinn Traveler')
    end
  end
end
