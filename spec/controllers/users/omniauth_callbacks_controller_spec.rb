require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'bike_index' do
    it 'creates a user when there is no user' do
      set_omniauth_bike_index
      expect {
        post :bike_index
      }.to change(User, :count).by(1)
      response.code.should eq('302')
      user = User.last
      expect(user.binx_id).to eq(omniauth_binx_fixture['uid'].to_i)
      expect(user.binx_credentials).to be_present
      expect(user.binx_info['credentials']).to_not be_present
    end
  end
end
