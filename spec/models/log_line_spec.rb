require 'rails_helper'

RSpec.describe LogLine, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:entry) }
    it { should validate_presence_of(:request_at) }
    it { should validate_presence_of(:source) }
    it { should validate_presence_of(:type) }
  end

  describe 'associations' do
    it { should belong_to(:ip_address) }
    it { should belong_to(:serial_search) }
  end
end
