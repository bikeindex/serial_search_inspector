require 'rails_helper'

describe PapertrailOutputProcessor do
  include_context :log_file_fixtures
  let(:instance) { PapertrailOutputProcessor.new }
  describe 'process_lines' do
    it 'returns an array of json hash log entries' do
      result = instance.process_lines(papertrail_log_fixture_path)
      result.each do |line|
        expect(line['remote_ip']).to be_present
        expect(line['@timestamp']).to be_present
      end
    end
  end

  describe 'entry_from_line' do
    context 'standard entry' do
      let(:line) { 'Sep 29 05:28:42 bikeindex production.log: {"@timestamp":"2016-09-29T10:28:42.711Z"}' }
      let(:target) { { '@timestamp' => '2016-09-29T10:28:42.711Z' } }
      it 'returns the entry' do
        expect(instance.entry_from_line(line)).to eq target
      end
    end
    context 'line without timestamp' do
      let(:line) { 'Sep 29 05:28:42 bikeindex production.log: {}' }
      let(:target) { { '@timestamp' => 'Sep 29 05:28:42Z' } }
      it 'adds the timestamp' do
        expect(instance.entry_from_line(line)).to eq target
      end
    end
  end

  describe 'create_log_lines' do
    it 'adds entries to the database' do
      expect do
        instance.create_log_lines(papertrail_log_fixture_path)
      end.to change(LogLine, :count).by 4
    end
  end

  describe 'create_log_lines_from_events' do
    context 'with timestamp' do
      let(:events) do
        [
          {
            id: 7711561783320576,
            received_at: '2011-05-18T20:30:02-07:00',
            display_received_at: 'May 18 20:30:02',
            source_ip: '208.75.57.121',
            source_name: 'abc',
            message: '{"method":"GET","path":"/bikes","format":"html","controller":"BikesController","action":"index","status":200,"duration":1176.41,"view":49.69,"db":1113.07,"remote_ip":"107.57.240.125","params":{"utf8":"✓","serial":"5903706","button":"","location":"","distance":"100","stolenness":""},"@timestamp":"2016-09-29T10:30:51.774Z","@version":"1","message":"[200] GET /bikes (BikesController#index)"}'
          }
        ]
      end
      it 'successfully creates a log_line' do
        expect do
          instance.create_log_lines_from_events(events)
        end.to change(LogLine, :count).by 1
      end
    end
    context 'without timestamp' do
      let(:events) do
        [
          {
            id: 7711561783320576,
            received_at: '2011-05-18T20:30:02-07:00',
            display_received_at: 'May 18 20:30:02',
            source_ip: '208.75.57.121',
            source_name: 'abc',
            message: '{"method":"GET","path":"/bikes","format":"html","controller":"BikesController","action":"index","status":200,"duration":1176.41,"view":49.69,"db":1113.07,"remote_ip":"107.57.240.125","params":{"utf8":"✓","serial":"5903706","button":"","location":"","distance":"100","stolenness":""},"@timestamp":"2016-09-29T10:30:51.774Z","@version":"1","message":"[200] GET /bikes (BikesController#index)"}'
          }
        ]
      end
      it 'successfully creates a log_line' do
        expect do
          instance.create_log_lines_from_events(events)
        end.to change(LogLine, :count).by 1
      end
    end
  end
end
