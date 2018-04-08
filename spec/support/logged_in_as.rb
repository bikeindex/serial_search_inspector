shared_context :logged_in_as_user do
  let(:user) { FactoryBot.create(:user) }
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end

shared_context :logged_in_as_superuser do
  let(:user) { FactoryBot.create(:superuser) }
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end
