require 'rails_helper'

RSpec.describe GraphsController, type: :controller do
  describe 'GET index' do
    it 'renders the index' do
      get :index
      expect(response.status).to eq 200
      expect(response).to render_template('index')
    end
  end

  describe 'unique_created_day' do
    it 'returns an array' do
      get :unique_created_day
      result = JSON.parse(response.body)
      expect(result.is_a?(Array)).to be true
      expect(response.status).to eq 200
    end
  end

  describe 'unique_created' do
    it 'returns an array' do
      get :unique_created, grouping: 'group_by_hour_of_day'
      result = JSON.parse(response.body)
      expect(result.is_a?(Array)).to be true
      expect(response.status).to eq '200'
    end
  end
end
