require 'rails_helper'

RSpec.describe SerialSearch, type: :model do
  include_context :log_line_fixtures

  let(:serial_search_1) { FactoryBot.create(:serial_search, searched_bike_index_at: 1.day.ago) }
  let(:serial_search_2) { FactoryBot.create(:serial_search, searched_bike_index_at: 2.hours.ago) }

  describe 'validations' do
    subject { FactoryBot.create(:serial_search) }
    it { should validate_presence_of(:serial) }
    it { should validate_uniqueness_of(:serial) }
  end

  describe 'associations' do
    it { should have_many(:log_lines) }
    it { should have_many(:ip_addresses) }
    it { should have_many(:bikes) }
    it { should have_many(:bike_serial_searches) }
  end

  describe 'valid_serial_search_for_bike_creation?' do
    context 'valid' do
      it 'returns true' do
        expect(serial_search_1.valid_serial_search_for_bike_creation?).to be_truthy
      end
    end
    context 'invalid' do
      it 'returns false' do
        expect(serial_search_2.valid_serial_search_for_bike_creation?).to be_falsey
      end
    end
  end

  describe 'within_min_request_time' do
    context 'less than the min_request_time' do
      it 'returns true' do
        expect(serial_search_2.within_min_request_time).to be_truthy
      end
    end
    context 'more than the min_request_time' do
      it 'returns false' do
        expect(serial_search_1.within_min_request_time).to be_falsey
      end
    end
  end

  describe 'sanitize_serial' do
    context 'w235 53214' do
      let(:dirty_serial) { SerialSearch.new(serial: 'w235 53214') }
      it 'cleans serial' do
        dirty_serial.sanitize_serial
        expect(dirty_serial.serial).to eq 'W235 53214'
      end
    end
    context ' b532 4324   ' do
      let(:dirty_serial) { SerialSearch.new(serial: ' b532 4324   ') }
      it 'cleans serial' do
        dirty_serial.sanitize_serial
        expect(dirty_serial.serial).to eq 'B532 4324'
      end
    end
    context 'before save cleans the serial' do
      let(:dirty_serial) { SerialSearch.new(serial: ' fGt233 45 12g  ') }
      it 'saves and cleans serial' do
        dirty_serial.save
        expect(dirty_serial.serial).to eq 'FGT233 45 12G'
      end
    end
  end

  describe '.text_search' do
    let(:serial_search) { FactoryBot.create(:serial_search, serial: 'Y524347') }

    context 'with a complete matched serial' do
      it 'returns the valid serial_search record' do
        expect(SerialSearch.text_search('Y524347')).to include(serial_search)
      end
    end

    context 'with a partial matched serial' do
      it 'returns the valid serial_search record' do
        expect(SerialSearch.text_search('Y524')).to include(serial_search)
      end
    end
  end
end
