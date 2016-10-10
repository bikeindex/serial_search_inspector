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
    context 'sort by number of searches' do
      let!(:ip_address_3) { FactoryGirl.create(:ip_address) }
      let!(:ip_address_2) { FactoryGirl.create(:ip_address) }
      before do
        FactoryGirl.create(:log_line, ip_address: ip_address_2)
        FactoryGirl.create(:log_line, ip_address: ip_address_3)
        FactoryGirl.create(:log_line, ip_address: ip_address_3)
      end
      it 'sorts correctly by number of searches' do
        get :index, sort: 'log_lines_count', direction: 'desc', per_page: '1'
        expect(response.status).to eq 200
        expect(assigns(:ip_addresses)).to eq([ip_address_3])
      end
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
