require 'rails_helper'

RSpec.describe LogLineAssociaterJob, type: :job do
  describe 'perform' do
    it 'should create an activejob to associate the logline to the IP address and Serial Search' do
      ActiveJob::Base.queue_adapter = :inline
      log_line = FactoryBot.create(:log_line)
      expect(UpdateLastRequestAtJob).to receive(:perform_later).with(log_line)
      expect(BikeIndexRequestorJob).to receive(:perform_later)
      LogLineAssociaterJob.perform_later
      log_line.reload
      expect(log_line.ip_address).to be_present
      expect(log_line.serial_search).to be_present
    end
  end
end
