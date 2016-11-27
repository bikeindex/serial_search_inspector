require 'rails_helper'

RSpec.describe GraphsController, type: :controller do
  context 'user' do
    include_context :logged_in_as_user
    describe 'GET index' do
      it 'redirects to root_url' do
        get :index
        expect(response).to redirect_to root_url
      end
    end

    describe 'source_type' do
      it 'redirects to root_url' do
        get :source_type
        expect(response).to redirect_to root_url
      end
    end

    describe 'uniquely_created_entries' do
      it 'redirects to root_url' do
        get :uniquely_created_entries, params: { grouping: 'day' }
        expect(response).to redirect_to root_url
      end
    end
  end

  context 'superuser' do
    let!(:serial_search) { FactoryGirl.create(:serial_search) }
    let!(:ip_address) { FactoryGirl.create(:ip_address) }
    let!(:log_line) { FactoryGirl.create(:log_line) }
    include_context :logged_in_as_superuser
    describe 'GET index' do
      it 'renders the index' do
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template('index')
        expect(assigns(:serial_searches)).to eq([serial_search])
        expect(assigns(:ip_addresses)).to eq([ip_address])
        expect(assigns(:log_lines)).to eq([log_line])
      end
    end

    describe 'source_type' do
      it 'returns an array' do
        get :source_type
        result = JSON.parse(response.body)
        pp result
        expect(result.is_a?(Array)).to be true
        expect(response.status).to eq 200
      end
    end

    describe 'uniquely_created_entries' do
      it 'returns an array' do
        get :uniquely_created_entries, params: { grouping: 'day' }
        result = JSON.parse(response.body)
        expect(result.is_a?(Array)).to be true
        expect(response.status).to eq 200
      end
    end
  end
end
