require 'rails_helper'

RSpec.describe IpAddress, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:address) }
  end

  describe 'associations' do
    it { should have_many(:log_lines) }
    it { should have_many(:serial_searches) }
  end

  describe 'inspector_address?' do
    context 'started_being_inspector_at present' do
      let(:ip_address) { FactoryGirl.create(:ip_address, address: 'sample_address', started_being_inspector_at: Date.parse('03-03-2013').to_time) }
      before do
        expect(ip_address).to be_present
      end
      it 'is inspector' do
        expect(IpAddress.inspector_address?(address: 'sample_address', request_at: Time.now)).to be_truthy
      end
    end
    context 'ip_address has both start and stop,' do
      let(:ip_address) { FactoryGirl.create(:ip_address, address: 'sample_address', started_being_inspector_at: Date.parse('01-07-2016').to_time, stopped_being_inspector_at: Date.parse('01-08-2016').to_time) }
      before do
        expect(ip_address).to be_present
      end
      context 'request between start and stop' do
        it 'is the inspector' do
          expect(IpAddress.inspector_address?(address: 'sample_address', request_at: Date.parse('18-07-2016').to_time)).to be_truthy
        end
      end
      context 'request before start' do
        it 'is not the inspector' do
          expect(IpAddress.inspector_address?(address: 'sample_address', request_at: Date.parse('01-06-2016').to_time)).to be_falsey
        end
      end
      context 'request after end' do
        it 'is not the inspector' do
          expect(IpAddress.inspector_address?(address: 'sample_address', request_at: Date.parse('01-09-2016').to_time)).to be_falsey
        end
      end
    end
    context 'ip_address.address not in database' do
      it 'is not inspector' do
        expect(IpAddress.inspector_address?(address: 'sample_address', request_at: Time.now)).to be_falsey
      end
    end
  end
end
