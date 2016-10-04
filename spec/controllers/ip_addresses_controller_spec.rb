require 'rails_helper'

RSpec.describe IpAddressesController, type: :controller do
  describe 'GET index' do
    let!(:ip_address) { FactoryGirl.create(:ip_address) }
    it 'renders the index' do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template('index')
      expect(assigns(:ip_addresses)).to eq([ip_address])
    end
  end
end
