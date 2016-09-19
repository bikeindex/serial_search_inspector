require 'rails_helper'

RSpec.describe IpAddress, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:address) }
  end

  describe 'associations' do
    it { should have_many(:log_lines) }
  end
end

