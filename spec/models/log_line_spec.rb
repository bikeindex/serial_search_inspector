require 'rails_helper'

RSpec.describe LogLine, type: :model do
  include_context :log_line_fixtures
  let(:parsed_log_fixture) { JSON.parse(File.read(log_fixture)) }
  let(:log) { LogLine.new(entry: parsed_log_fixture) }

  describe 'validations' do
    it { should validate_presence_of(:entry) }
    it { should validate_presence_of(:request_at) }
    it { should validate_presence_of(:search_source) }
  end

  describe 'associations' do
    it { should belong_to(:ip_address) }
    it { should belong_to(:serial_search) }
  end

  describe 'factory' do
    let!(:log_line) { FactoryGirl.create(:log_line) }
    it 'works correctly' do
      expect(log_line.request_at).to be_within(1.second).of Time.now
    end
  end

  describe 'serial' do
    context 'valid serial number' do
      let(:log_fixture) { log_line_fixture }
      it 'returns true' do
        expect(log.serial.present?).to be_truthy
      end
    end
    context 'empty serial number' do
      let(:log_fixture) { log_line_fixture_empty_serial }
      it 'returns true' do
        expect(log.serial.present?).to be_falsey
      end
    end
    context 'no serial number' do
      let(:log_fixture) { log_line_fixture_no_serial }
      it 'returns true' do
        expect(log.serial.present?).to be_falsey
      end
    end
    context 'returns sanitized serial' do
      let(:log_fixture) { log_line_fixture_dirty_serial }
      it 'cleans serial' do
        expect(log.serial).to eq 'WSBC60 2203254K'
      end
    end
  end

  describe 'find_search_source' do
    context 'html' do
      let(:log_fixture) { log_line_fixture }
      it 'returns html' do
        expect(log.find_search_source).to eq 'html'
      end
    end
    context 'api v1' do
      let(:log_fixture) { log_line_fixture_find_search_source_apiv1 }
      it 'returns api v1' do
        expect(log.find_search_source).to eq 'api/v1'
      end
    end
    context 'api v2' do
      let(:log_fixture) { log_line_fixture_find_search_source_apiv2 }
      it 'returns api v2' do
        expect(log.find_search_source).to eq 'api/v2'
      end
    end
    context 'api v3' do
      let(:log_fixture) { log_line_fixture_find_search_source_apiv3 }
      it 'returns api v3' do
        expect(log.find_search_source).to eq 'api/v3'
      end
    end
  end

  describe 'find_search_type' do
    context 'widget' do
      let(:log_fixture) { log_line_fixture_find_search_type_widget }
      it 'returns widget type' do
        expect(log.find_search_type).to eq 'widget'
      end
    end
    context 'multi' do
      let(:log_fixture) { log_line_fixture_find_search_type_multi }
      it 'returns mutli type' do
        expect(log.find_search_type).to eq 'multi'
      end
    end
    context 'nil' do
      let(:log_fixture) { log_line_fixture }
      it 'returns nil' do
        expect(log.find_search_type).to eq nil
      end
    end
  end

  describe 'serial_length_insufficient?' do
    context 'serial number is 3 or shorter' do
      let(:log_fixture) { log_line_fixture_serial_length_shorter }
      it 'returns true' do
        expect(log.serial_length_insufficient?).to be_truthy
      end
    end
    context 'serial number is greater than 3' do
      let(:log_fixture) { log_line_fixture }
      it 'returns false' do
        expect(log.serial_length_insufficient?).to eq false
      end
    end
  end

  describe 'inspector_request?' do
    let(:log_fixture) { log_line_fixture }
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
      let(:log_fixture) { log_line_fixture_find_location_present }
      it 'returns a location string' do
        expect(log.find_location).to eq 'Davis, CA'
      end
    end
    context 'no location present' do
      let(:log_fixture) { log_line_fixture }
      it 'returns nil' do
        expect(log.find_location).to eq nil
      end
    end
    context 'empty string' do
      let(:log_fixture) { log_line_fixture_find_location_empty_string }
      it 'returns nil' do
        expect(log.find_location).to eq nil
      end
    end
  end

  describe 'find_request_at' do
    let(:log_fixture) { log_line_fixture }
    it 'returns correct time object' do
      expect(log.find_request_at).to eq Time.parse('2016-09-22T05:24:38.139Z')
    end
  end

  describe 'attributes_from_entry' do
    context 'valid serial number' do
      let(:log_fixture) { log_line_fixture }
      it 'returns hash for creation' do
        allow(IpAddress).to receive(:inspector_address?) { false }
        attributes = log.attributes_from_entry
        expect(attributes[:request_at]).to eq Time.parse('2016-09-22T05:24:38.139Z')
        expect(attributes[:search_source]).to eq 'html'
        expect(attributes[:search_type]).to eq nil
        expect(attributes[:insufficient_length]).to be_falsey
        expect(attributes[:inspector_request]).to be_falsey
        expect(attributes[:entry_location]).to be nil
      end
    end
  end

  describe 'create_log_line' do
    context 'with valid serial' do
      let(:log_fixture) { log_line_fixture }
      context 'first create' do
        it 'creates a new logline' do
          expect do
            LogLine.create_log_line(parsed_log_fixture)
          end.to change(LogLine, :count).by 1
        end
      end
      context 'same timestamp log_line' do
        before do
          LogLine.create_log_line(parsed_log_fixture)
        end
        context 'same serial' do
          it 'does not create a new logline' do
            expect do
              LogLine.create_log_line(parsed_log_fixture)
            end.to change(LogLine, :count).by 0
          end
        end
        context 'different serial search' do
          it 'creates a second logline' do
            log_fixture_2 = parsed_log_fixture
            log_fixture_2['params']['serial'] = 'abc'
            expect do
              LogLine.create_log_line(log_fixture_2)
            end.to change(LogLine, :count).by 1
          end
        end
      end
    end
    context 'no serial does not create' do
      let(:log_fixture) { log_line_fixture_no_serial }
      it 'does not creates a new logline' do
        expect do
          LogLine.create_log_line(parsed_log_fixture)
        end.to change(LogLine, :count).by 0
      end
    end
    context 'empty serial does not create' do
      let(:log_fixture) { log_line_fixture_empty_serial }
      it 'does not creates a new logline' do
        expect do
          LogLine.create_log_line(parsed_log_fixture)
        end.to change(LogLine, :count).by 0
      end
    end
  end

  describe 'find_or_create_ip_address_association' do
    let(:log_fixture) { log_line_fixture }
    context 'a new ip address' do
      it 'creates in database' do
        expect do
          log.find_or_create_ip_address_association
        end.to change(IpAddress, :count).by 1
      end
      it 'associates with logline' do
        log.find_or_create_ip_address_association
        expect(log.ip_address.address).to eq log.entry_ip_address
      end
    end
    context 'ip address already exists' do
      let(:ip_address) { FactoryGirl.create(:ip_address, address: '111.222.333.444') }
      let(:created_log) { FactoryGirl.create(:log_line, entry: parsed_log_fixture) }
      it 'associates with that ip' do
        expect(ip_address).to be_present
        log.find_or_create_ip_address_association
        expect(log.ip_address).to eq ip_address
      end
    end
  end

  describe 'find_or_create_serial_search_association' do
    context 'valid serial' do
      let!(:serial_search) { FactoryGirl.create(:serial_search) }
      let(:log_fixture) { log_line_fixture }
      it 'creates a new serial in the database' do
        expect do
          log.find_or_create_serial_search_association
        end.to change(SerialSearch, :count).by 1
        expect(log.serial_search.serial).to eq log.serial
      end
    end
    context 'invalid serial (length)' do
      let(:log_fixture) { log_line_fixture_serial_length_shorter }
      it 'does not create a SerialSearch' do
        expect do
          log.find_or_create_serial_search_association
        end.to change(SerialSearch, :count).by 0
      end
    end
    context 'SerialSearch already exists' do
      let(:log_fixture) { log_line_fixture }
      let(:serial_search) { FactoryGirl.create(:serial_search, serial: "#{parsed_log_fixture['params']['serial'].strip.upcase}  ") }
      it 'does not create a new serial and associates' do
        expect(serial_search).to be_present
        expect do
          log.find_or_create_serial_search_association
        end.to change(SerialSearch, :count).by 0
        expect(log.serial_search).to eq serial_search
      end
    end
  end
end
