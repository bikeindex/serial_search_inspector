require 'rails_helper'

RSpec.describe LogLine, type: :model do
  let(:parsed_log_fixture) { JSON.parse(log_fixture) }
  let(:log) { LogLine.new(entry: parsed_log_fixture) }

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

  describe 'serial?' do
    context 'valid serial number' do
      let(:log_fixture) { File.read('./spec/fixtures/parse_log_single_serial.json') }
      it 'returns true' do
        expect(log.serial?).to be_truthy
      end
    end
    context 'empty serial number' do
      let(:log_fixture) { File.read('./spec/fixtures/parse_log_empty_serial.json') }
      it 'returns true' do
        expect(log.serial?).to be_falsey
      end
    end
    context 'no serial number' do
      let(:log_fixture) { File.read('./spec/fixtures/parse_log_no_serial.json') }
      it 'returns true' do
        expect(log.serial?).to be_falsey
      end
    end
  end

  # describe 'attributes_from_entry' do
  #   context 'valid serial number' do
  #     let(:log_fixture) { File.read('./spec/fixtures/attributes_from_entry.json') }
  #     it 'returns hash for creation' do
  #       log.attributes_from_entry
  #       expect(log.request_at).to eq 'abc'
  #       expect(log.source).to eq 'abcc'
  #       expect(log.type).to eq 'fds'
  #       expect(log.insufficient_length).to be_falsey
  #       expect(log.inspector_request).to be_falsey
  #       # expect(log.entry_location).to be 'somewhere'
  #     end
  #   end
  # end

  # type: Widget / multi
  # source: html, api v1/v2/v3
  # length: 3

  it 'no serial does not create'
  it 'empty serial > does not create'
  it 'inspector request'
  it 'location / geocode'
  it 'creation'
  it 'check_length'
end
