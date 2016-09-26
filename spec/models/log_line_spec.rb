require 'rails_helper'

RSpec.describe LogLine, type: :model do
  let(:parsed_log_fixture) { JSON.parse(log_fixture) }
  let(:log) { LogLine.new(entry: parsed_log_fixture) }

  describe 'validations' do
    it { should validate_presence_of(:entry) }
    it { should validate_presence_of(:request_at) }
    it { should validate_presence_of(:source) }
  end

  describe 'associations' do
    it { should belong_to(:ip_address) }
    it { should belong_to(:serial_search) }
  end

  describe 'serial' do
    context 'valid serial number' do
      let(:log_fixture) { File.read('./spec/fixtures/parse_log_single_serial.json') }
      it 'returns true' do
        expect(log.serial.present?).to be_truthy
      end
    end
    context 'empty serial number' do
      let(:log_fixture) { File.read('./spec/fixtures/parse_log_empty_serial.json') }
      it 'returns true' do
        expect(log.serial.present?).to be_falsey
      end
    end
    context 'no serial number' do
      let(:log_fixture) { File.read('./spec/fixtures/parse_log_no_serial.json') }
      it 'returns true' do
        expect(log.serial.present?).to be_falsey
      end
    end
  end

  describe 'find_source' do
    context 'html' do
      let(:log_fixture) { File.read('./spec/fixtures/find_source_html.json') }
      it 'returns html' do
        expect(log.find_source).to eq 'html'
      end
    end
    context 'api v1' do
      let(:log_fixture) { File.read('./spec/fixtures/find_source_apiv1.json') }
      it 'returns api v1' do
        expect(log.find_source).to eq 'api/v1'
      end
    end
    context 'api v2' do
      let(:log_fixture) { File.read('./spec/fixtures/find_source_apiv2.json') }
      it 'returns api v2' do
        expect(log.find_source).to eq 'api/v2'
      end
    end
    context 'api v3' do
      let(:log_fixture) { File.read('./spec/fixtures/find_source_apiv3.json') }
      it 'returns api v3' do
        expect(log.find_source).to eq 'api/v3'
      end
    end
  end

  describe 'find_search_type' do
    context 'widget' do
      let(:log_fixture) { File.read('./spec/fixtures/find_type_widget.json') }
      it 'returns widget type' do
        expect(log.find_search_type).to eq 'widget'
      end
    end
    context 'multi' do
      let(:log_fixture) { File.read('./spec/fixtures/find_type_mutli.json') }
      it 'returns mutli type' do
        expect(log.find_search_type).to eq 'multi'
      end
    end
    context 'nil' do
      let(:log_fixture) { File.read('./spec/fixtures/find_type_nil.json') }
      it 'returns nil' do
        expect(log.find_search_type).to eq nil
      end
    end
  end

  describe 'serial_length_insufficient?' do
    context 'serial number is 3 or shorter' do
      let(:log_fixture) { File.read('./spec/fixtures/check_length_shorter.json') }
      it 'returns true' do
        expect(log.serial_length_insufficient?).to be_truthy
      end
    end
    context 'serial number is greater than 3' do
      let(:log_fixture) { File.read('./spec/fixtures/check_length_ok.json') }
      it 'returns false' do
        expect(log.serial_length_insufficient?).to eq false
      end
    end
  end

  describe 'inspector_request?' do
    let(:log_fixture) { File.read('./spec/fixtures/attributes_from_entry.json') }
    let(:args) { { address: log.entry['remote_ip'], request_at: log.find_request_at } }
    context 'is currently inspector' do
      it 'return true' do
        expect(IpAddress).to receive(:inspector_address?).with(args) { true }
        log.inspector_request?
      end
    end
    context 'is not currently inspector' do
      it 'return false' do
        expect(IpAddress).to receive(:inspector_address?).with(args) { false }
        log.inspector_request?
      end
    end
  end

  describe 'find_location' do
    context 'location present' do
      let(:log_fixture) { File.read('./spec/fixtures/find_location_present.json') }
      it 'returns a location string' do
        expect(log.find_location).to eq 'Davis, CA'
      end
    end
    context 'no location present' do
      let(:log_fixture) { File.read('./spec/fixtures/find_location_not_present.json') }
      it 'returns nil' do
        expect(log.find_location).to eq nil
      end
    end
    context 'empty string' do
      let(:log_fixture) { File.read('./spec/fixtures/find_location_empty_string.json') }
      it 'returns nil' do
        expect(log.find_location).to eq nil
      end
    end
  end

  describe 'find_request_at' do
    let(:log_fixture) { File.read('./spec/fixtures/find_request_at.json') }
    it 'returns correct time object' do
      expect(log.find_request_at).to eq Time.parse('2016-09-22T16:08:15.896Z')
    end
  end

  describe 'attributes_from_entry' do
    context 'valid serial number' do
      let(:log_fixture) { File.read('./spec/fixtures/attributes_from_entry.json') }
      it 'returns hash for creation' do
        attributes = log.attributes_from_entry
        expect(attributes[:request_at]).to eq Time.parse('2016-09-21T19:14:49.085Z')
        expect(attributes[:source]).to eq 'html'
        expect(attributes[:search_type]).to eq nil
        expect(attributes[:insufficient_length]).to be_falsey
        expect(attributes[:inspector_request]).to be_falsey
        expect(attributes[:entry_location]).to be nil
      end
    end
  end

  describe 'create_log_line' do
    context 'with valid serial' do
      let(:log_fixture) { File.read('./spec/fixtures/create_log_line_valid_serial.json') }
      context 'first create' do
        it 'creates a new logline' do
          expect do
            LogLine.create_log_line(parsed_log_fixture)
          end.to change(LogLine, :count).by 1
        end
      end
      context 'same log_line does not create two' do
        before do
          LogLine.create_log_line(parsed_log_fixture)
        end
        it 'does not create a new logline' do
          expect do
            LogLine.create_log_line(parsed_log_fixture)
          end.to change(LogLine, :count).by 0
        end
      end
    end
    context 'no serial does not create' do
      let(:log_fixture) { File.read('./spec/fixtures/create_log_line_no_serial.json') }
      it 'does not creates a new logline' do
        expect do
          LogLine.create_log_line(log_fixture)
        end.to change(LogLine, :count).by 0
      end
    end
    context 'empty serial does not create' do
      let(:log_fixture) { File.read('./spec/fixtures/create_log_line_empty_serial.json') }
      it 'does not creates a new logline' do
        expect do
          LogLine.create_log_line(log_fixture)
        end.to change(LogLine, :count).by 0
      end
    end
  end
end
