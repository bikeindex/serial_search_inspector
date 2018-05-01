require 'rails_helper'

RSpec.describe IpAddressesController, type: :controller do
  let!(:ip_address) { FactoryBot.create(:ip_address) }

  context 'user' do
    include_context :logged_in_as_user
    describe 'GET index' do
      it 'redirects to root_url' do
        get :index
        expect(response).to redirect_to root_url
      end
    end

    describe 'GET show' do
      it 'redirect to root_url' do
        get :show, params: { id: ip_address.id }
        expect(response).to redirect_to root_url
      end
    end

    describe 'GET edit' do
      it 'redirects to root_url' do
        get :edit, params: { id: ip_address.id }
        expect(response).to redirect_to root_url
      end
    end

    describe 'PUT update/:id' do
      let(:submitted_parameters) do
        {
          ip_address: {
            name:  'turtle',
            notes: 'seth smells',
            started_being_inspector_at: '',
            stopped_being_inspector_at: ''
          },
          id: ip_address.id
        }
      end
      it 'redirects to root_url' do
        put :update, params: submitted_parameters
        expect(response).to redirect_to root_url
      end
    end
  end

  context 'superuser' do
    include_context :logged_in_as_superuser
    describe 'GET index' do
      it 'renders the index' do
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template('index')
        expect(assigns(:ip_addresses)).to eq([ip_address])
      end
      context 'sort by number of searches' do
        let!(:ip_address_3) { FactoryBot.create(:ip_address) }
        let!(:ip_address_2) { FactoryBot.create(:ip_address) }
        before do
          FactoryBot.create(:log_line, ip_address: ip_address_2)
          FactoryBot.create(:log_line, ip_address: ip_address_3)
          FactoryBot.create(:log_line, ip_address: ip_address_3)
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
        let(:log_line) { FactoryBot.create(:log_line, ip_address: ip_address, request_at: 1.hour.ago) }
        let(:submitted_parameters) do
          {
            ip_address: {
              name:  'BIKES',
              notes: 'DJKLAASDLKJ',
              started_being_inspector_at: '2016-10-11T16:01',
              stopped_being_inspector_at: ''
            },
            id: ip_address.id
          }
        end
        it 'updates the model' do
          ip_address.update_attribute(:address, log_line.entry_ip_address)
          ip_address.log_lines << log_line
          put :update, params: submitted_parameters
          ip_address.reload
          log_line.reload
          expect(response).to redirect_to(ip_address_path(ip_address))
          expect(ip_address.name).to eq submitted_parameters[:ip_address][:name]
          expect(ip_address.notes).to eq submitted_parameters[:ip_address][:notes]
          expect(ip_address.started_being_inspector_at).to eq Time.zone.parse(submitted_parameters[:ip_address][:started_being_inspector_at])
          expect(log_line.inspector_request).to be_truthy
        end
      end
      context 'with ip_address that has times' do
        let(:submitted_parameters) do
          {
            ip_address: {
              name:  'turtle',
              notes: 'seth smells',
              started_being_inspector_at: '',
              stopped_being_inspector_at: ''
            },
            id: ip_address.id
          }
        end
        it 'removes started_being_inspector_at and stopped_being_inspector_at' do
          ip_address.update_attributes(
            started_being_inspector_at: '2016-10-11T16:01',
            stopped_being_inspector_at: '2016-10-13T16:01'
          )
          expect(ip_address.started_being_inspector_at).to eq Time.zone.parse('2016-10-11T16:01')
          put :update, params: submitted_parameters
          ip_address.reload
          expect(response).to redirect_to(ip_address_path(ip_address))
          expect(ip_address.name).to eq submitted_parameters[:ip_address][:name]
          expect(ip_address.notes).to eq submitted_parameters[:ip_address][:notes]
          expect(ip_address.started_being_inspector_at).to be_nil
          expect(ip_address.stopped_being_inspector_at).to be_nil
        end
      end
    end
  end
end
