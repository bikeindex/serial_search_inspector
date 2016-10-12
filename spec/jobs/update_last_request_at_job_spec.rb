require 'rails_helper'

RSpec.describe UpdateLastRequestAtJob, type: :job do
  describe 'perform' do
    context 'serial searched before' do
      let(:target_time) { Time.now + 2.minutes }
      let(:old_time) { Time.now - 5.minutes }
      let(:serial_search) { FactoryGirl.create(:serial_search, last_request_at: old_time) }
      let(:ip_address) { FactoryGirl.create(:ip_address, last_request_at: old_time) }
      let!(:log_line) { FactoryGirl.create(:log_line, request_at: target_time, serial_search: serial_search, ip_address: ip_address) }
      let!(:log_line_2) { FactoryGirl.create(:log_line, request_at: old_time, serial_search: serial_search, ip_address: ip_address) }
      it 'updates to most recent time' do
        ActiveJob::Base.queue_adapter = :inline
        serial_search.reload
        expect(serial_search.last_request_at).to be_within(1.second).of old_time
        expect(ip_address.last_request_at).to be_within(1.second).of old_time
        UpdateLastRequestAtJob.perform_later(log_line)
        serial_search.reload
        ip_address.reload
        expect(serial_search.last_request_at).to be_within(1.second).of target_time
        expect(ip_address.last_request_at).to be_within(1.second).of target_time
      end
    end
  end
end
