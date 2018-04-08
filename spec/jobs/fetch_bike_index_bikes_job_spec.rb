require 'rails_helper'

RSpec.describe FetchBikeIndexBikesJob, type: :feature do
  describe 'perform' do
    let(:user) { FactoryBot.create(:user) }
    let(:binx_bikes) { JSON.parse(File.read(Rails.root.join('spec/fixtures/binx_bikes.json'))) }

    before do
      ActiveJob::Base.queue_adapter = :inline
      expect_any_instance_of(BikeIndex::Requester).to receive(:request_bikes) { binx_bikes }
    end

    it 'stores Bike Index bikes on the user' do
      FetchBikeIndexBikesJob.new.perform(user)

      expect(user.binx_bikes).to_not be_empty
      expect(user.binx_bikes).to be_a(Hash)
      expect(user.binx_bikes).to eq(binx_bikes)
    end

    it 'creates a bike if there is not one' do
      expect(Bike.count).to eq(0)
      FetchBikeIndexBikesJob.new.perform(user)

      expect(Bike.count).to eq(1)
      expect(user.bikes.first.user_id).to eq(user.id)
    end
  end
end
