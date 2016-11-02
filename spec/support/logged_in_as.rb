shared_context :logged_in_as_user do
  let(:user) { FactoryGirl.create(:user) }
  before do
    set_current_user(user)
  end
end
