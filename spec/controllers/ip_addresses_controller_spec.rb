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
        get :index, params: { sort: 'log_lines_count', direction: 'desc', per_page: '1' }
        expect(response.status).to eq 200
        expect(assigns(:ip_addresses)).to eq([ip_address_3])
      end
    end
  end

  describe 'GET show' do
    it 'renders the show' do
      get :show, params: { id: ip_address.id }
      expect(response.status).to eq 200
      expect(response).to render_template('show')
      expect(assigns(:ip_address)).to eq ip_address
    end
  end

  describe 'GET edit' do
    it 'renders the edit page' do
      get :edit, params: { id: ip_address.id }
      expect(response.status).to eq 200
      expect(response).to render_template('edit')
      expect(assigns(:ip_address)).to eq ip_address
    end
  end

  describe 'PUT update/:id' do
    context 'with times' do
      let(:submitted_parameters) do
        {
          ip_address: {
            name:  'BIKES',
            notes: 'DJKLAASDLKJ'
          },
          id: ip_address.id
        }
      end
      it 'updates the model' do
        put :update, params: submitted_parameters
        ip_address.reload
        expect(response).to redirect_to(ip_address_path(ip_address))
        expect(ip_address.name).to eq submitted_parameters[:ip_address][:name]
        expect(ip_address.notes).to eq submitted_parameters[:ip_address][:notes]
      end
    end
    context 'with ip_address that has times' do
      it 'removes started_being_inspector_at and stopped_being_inspector_at'
    end
  end
end
