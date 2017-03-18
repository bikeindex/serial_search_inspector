require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe 'ensure_superuser' do
    context 'with no cookies' do
      it 'redirects the request' do
        get :index

        expect(response.status).to eq(302)
      end
    end
  end
end
