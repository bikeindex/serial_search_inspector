require 'rails_helper'

RSpec.describe SearchedBikeIndexLastJob, type: :job do
  # include_context :log_line_fixtures
  # let(:log_line) { LogLine.new(entry: JSON.parse(File.read(log_line_fixture))) }

  describe 'perform' do
    let!(:log_line) { FactoryGirl.create(:log_line, request_at: Time.now) }
    let!(:serial_search) { FactoryGirl.create(:serial_search, serial: log_line.serial) }
    context 'a new serial' do
      it 'sets searched_bike_index_at' do
        ActiveJob::Base.queue_adapter = :inline
        SearchedBikeIndexLastJob.perform_later(serial_search)
        expect(serial_search.searched_bike_index_at).to be_within(1.second).of Time.now
      end
    end
  end
end

  #   context 'sets searched_bike_index_at' do
  #     let(:log_fixture) { log_line_fixture }
  #     context 'new serial_search' do
  #       it 'sets time correctly' do
  #         log.find_or_create_serial_search_association
  #         serial_search = SerialSearch.first
  #         expect(serial_search.searched_bike_index_at).to eq Time.parse(parsed_log_fixture['@timestamp'])
  #       end
  #     end

        # use this test

  #     context 'serial searched before' do
  #       let(:target_time) { Time.now + 2.minutes }
  #       let(:serial_search) { FactoryGirl.create(:serial_search, serial: log.serial) }
  #       let!(:log_line) { FactoryGirl.create(:log_line, request_at: target_time, serial_search: serial_search) }
  #       it 'updates to most recent time' do
  #         log.update_attribute(:request_at, Time.now - 2.minutes)
  #         log.find_or_create_serial_search_association
  #         serial_search = SerialSearch.first
  #         expect(serial_search.searched_bike_index_at).to be_within(1.second).of target_time
  #       end
  #     end
  #   end
  # end
