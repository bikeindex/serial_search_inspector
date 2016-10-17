require 'rails_helper'

RSpec.describe SerialSearch, type: :model do
  include_context :log_line_fixtures
  describe 'validations' do
    it { should validate_presence_of(:serial) }
    it { should validate_uniqueness_of(:serial) }
  end

  describe 'associations' do
    it { should have_many(:log_lines) }
    it { should have_many(:ip_addresses) }
    it { should have_and_belong_to_many(:bikes) }
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
end
