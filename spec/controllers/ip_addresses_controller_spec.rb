require 'rails_helper'

RSpec.describe IpAddressesController, type: :controller do
  let!(:ip_address) { FactoryGirl.create(:ip_address) }
  describe 'GET index' do
    it 'renders the index' do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template('index')
      expect(assigns(:ip_addresses)).to eq([ip_address])
    end
  end

  describe 'GET show' do
    it 'renders the show' do
      get :show, id: ip_address.id
      expect(response.status).to eq 200
      expect(response).to render_template('show')
      expect(assigns(:ip_address)).to eq ip_address
    end
  end
end
