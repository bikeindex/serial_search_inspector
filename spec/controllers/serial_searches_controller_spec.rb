require 'rails_helper'

RSpec.describe SerialSearchesController, type: :controller do
  let!(:serial_search) { FactoryBot.create(:serial_search) }

  context 'user' do
    include_context :logged_in_as_user

    describe 'GET index' do
      it 'renders the index' do
        get :index
        expect(response.status).to eq 200
        expect(response).to render_template('index')
        expect(assigns(:serial_searches)).to be_nil
      end
    end

    describe 'GET show' do
      it 'redirects to root_url' do
        get :show, params: { id: serial_search.id }
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
        expect(response).to render_template('superuser')
        expect(assigns(:serial_searches)).to eq([serial_search])
      end
    end

    context 'sort by times_searched' do
      let!(:serial_search_3) { FactoryBot.create(:serial_search) }
      let!(:serial_search_2) { FactoryBot.create(:serial_search) }

      before do
        FactoryBot.create(:log_line, serial_search: serial_search_2)
        FactoryBot.create(:log_line, serial_search: serial_search_3)
        FactoryBot.create(:log_line, serial_search: serial_search_3)
      end

      it 'sorts by times_searched' do
        get :index, params: { sort: 'log_lines_count', direction: 'desc', per_page: '1' }
        expect(response.status).to eq 200
        expect(assigns(:serial_searches)).to eq([serial_search_3])
      end
    end

    context 'sort by last request at' do
      let!(:serial_search_1) { FactoryBot.create(:serial_search, serial: 'WTU 326', log_lines_count: '2') }
      let!(:serial_search_2) { FactoryBot.create(:serial_search, serial: 'WTU 316', log_lines_count: '3') }

      it 'sorts correctly when switching direction' do
        get :index, params: { sort: 'log_lines_count', direction: 'asc', query: 'WTU' }

        expect(response.status).to eq 200
        expect(assigns(:serial_searches)).to eq([ serial_search_1, serial_search_2])

        get :index, params: { sort: 'log_lines_count', direction: 'desc', query: 'WTU' }
        expect(assigns(:serial_searches)).to eq([serial_search_2, serial_search_1])
      end
    end

    describe 'GET show' do
      it 'renders the show' do
        get :show, params: { id: serial_search.id }
        expect(response.status).to eq 200
        expect(response).to render_template('show')
        expect(assigns(:serial_search)).to eq serial_search
      end
    end
  end
end
