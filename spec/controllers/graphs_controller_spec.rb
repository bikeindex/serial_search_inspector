require 'rails_helper'

RSpec.describe GraphsController, type: :controller do
  describe 'GET index' do
    it 'renders the index' do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template('index')
    end
  end

  describe 'uniquely_created_entries' do
    it 'returns an array' do
      get :uniquely_created_entries, grouping: 'day'
      result = JSON.parse(response.body)
      expect(result.is_a?(Array)).to be true
      expect(response.status).to eq 200
    end
  end
end
