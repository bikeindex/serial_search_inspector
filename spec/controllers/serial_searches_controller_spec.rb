require 'rails_helper'

RSpec.describe SerialSearchesController, type: :controller do
  let!(:serial_search) { FactoryGirl.create(:serial_search) }
  describe 'GET index' do
    it 'renders the index' do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template('index')
      expect(assigns(:serial_searches)).to eq([serial_search])
    end
  end

  describe 'GET show' do
    it 'renders the show' do
      get :show, id: serial_search.id
      expect(response.status).to eq 200
      expect(response).to render_template('show')
      expect(assigns(:serial_search)).to eq serial_search
    end
  end
end
