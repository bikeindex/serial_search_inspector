require 'rails_helper'

RSpec.describe RetrieveBikeIndexBikesJob, type: :job do
  binx_response = {
    'bikes' =>
      [{
        'id' => 30569,
        'title' => 'Schwinn Traveler',
        'serial' => 'Y524347',
        'manufacturer_name' => 'Schwinn',
        'frame_model' => 'Traveler',
        'year' => nil,
        'frame_colors' => ['Red', 'Black'],
        'thumb' =>
         'https://files.bikeindex.org/uploads/Pu/15678/small_IMG_20141028_140215450.jpg',
        'large_img' =>
         'https://files.bikeindex.org/uploads/Pu/15678/large_IMG_20141028_140215450.jpg',
        'is_stock_img' => false,
        'stolen' => false,
        'stolen_location' => nil,
        'date_stolen' => nil
      }]
  }

  describe 'perform' do
    let(:user) { FactoryGirl.create(:user, binx_id: 6335) }

    xit 'stores BikeIndexBike on the user' do
      ActiveJob::Base.queue_adapter = :inline
      RetrieveBikeIndexBikesJob.perform_later(user)
      # Issue with the binx_credentials['token']

      # expect(user.binx_bikes).to eq(binx_response)
      # expect(CheckForBikeSerialSearchesJob).to be_called
    end
  end
end
