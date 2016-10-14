require 'rails_helper'

describe BikeIndexRequestor do
  let(:instance) { BikeIndexRequestor.new }
  let(:serial_search) { FactoryGirl.create(:serial_search, serial: 'some number') }
  let(:stolen_serial_search) { FactoryGirl.create(:serial_search, serial: 'stolen_serial_number') }
  let(:target_find_bikes_with_serial_response) do
    {
      bikes: [
        {
          id: 30080,
          title: '2014 Jamis Allegro Sport Femme',
          serial: 'some serial number',
          manufacturer_name: 'Jamis',
          frame_model: 'Allegro Sport Femme',
          year: 2014,
          frame_colors: [
            'Blue'
          ],
          thumb: 'https://bikebook.s3.amazonaws.com/uploads/Fr/9984/small_14_allegrosportfemme_wh.jpg',
          large_img: 'https://bikebook.s3.amazonaws.com/uploads/Fr/9984/14_allegrosportfemme_wh.jpg',
          is_stock_img: true,
          stolen: false,
          stolen_location: nil,
          date_stolen: nil
        }
      ]
    }.as_json
  end
  let(:target_stolen_find_bikes_with_serial_response) do
    {
      bikes: [
        {
          id: 3414,
          title: '2014 Jamis Allegro Comp Disc',
          serial: 'stolen_serial_number',
          manufacturer_name: 'Jamis',
          frame_model: 'Allegro Comp Disc',
          year: 2014,
          frame_colors: [
            'Blue'
          ],
          thumb: 'https://bikebook.s3.amazonaws.com/uploads/Fr/9979/small_14_allegrocompdisc_bk.jpg',
          large_img: 'https://bikebook.s3.amazonaws.com/uploads/Fr/9979/14_allegrocompdisc_bk.jpg',
          is_stock_img: true,
          stolen: true,
          stolen_location: 'Chicago,IL,60647',
          date_stolen: 1400565600
        }
      ]
    }.as_json
  end
  describe 'find_bikes_with_serial' do
    context 'not stolen bike' do
      it 'searches by serial' do
        VCR.use_cassette('bike_index_requestor_find_bikes_with_serial') do
          expect(instance.find_bikes_with_serial(serial_search.serial)).to eq target_find_bikes_with_serial_response
        end
      end
    end
    context 'stolen bike' do
      it 'searches by serial' do
        VCR.use_cassette('bike_index_requestor_find_bikes_with_serial_stolen') do
          expect(instance.find_bikes_with_serial(stolen_serial_search.serial)).to eq target_stolen_find_bikes_with_serial_response
        end
      end
    end
  end
  describe 'create_bike_hashes_for_serial' do
    context 'not stolen' do
      let(:target) { [{ serial_search_id: serial.id, bike_index_id: 30080, stolen: false, date_stolen: nil }] }
      it 'returns hash' do
        expect(instance).to receive(:find_bikes_with_serial) { target_find_bikes_with_serial_response }
        expect(instance.create_bike_hashes_for_serial(serial_search)).to eq target
      end
    end
    context 'stolen' do
      let(:target) { [{ serial_search_id: stolen_serial.id, bike_index_id: 3414, stolen: true, date_stolen: Time.parse('2014-05-20 01:00:00 -0500') }] }
      it 'returns a hash' do
        expect(instance).to receive(:find_bikes_with_serial) { target_stolen_find_bikes_with_serial_response }
        expect(instance.create_bike_hashes_for_serial(stolen_serial_search)).to eq target
      end
    end
  end
end
