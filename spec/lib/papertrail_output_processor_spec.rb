require 'rails_helper'

describe PapertrailOutputProcessor do
  let(:instance) { PapertrailOutputProcessor.new }
  let(:papertrail_log_fixture_path) { './spec/fixtures/papertrail_output.log' }

  describe 'filter_lines' do
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
end
