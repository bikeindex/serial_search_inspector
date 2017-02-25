shared_context :logged_in_as_user do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end

shared_context :logged_in_as_superuser do
  let(:user) { FactoryGirl.create(:superuser) }
  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in user
  end
end
