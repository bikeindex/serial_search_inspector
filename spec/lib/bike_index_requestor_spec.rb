require 'rails_helper'

describe BikeIndexRequestor do
  let(:instance) { BikeIndexRequestor.new }
  let(:serial) { 'some number' }
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
  describe 'find_bikes_with_serial' do
    it 'searches by serial' do
      VCR.use_cassette('bike_index_requestor_find_bikes_with_serial') do
        expect(instance.find_bikes_with_serial(serial)).to eq target_find_bikes_with_serial_response
      end
    end
  end
  describe 'create_bike_hashes_for_serial' do
    let(:target) { [{ bike_index_id: 30080, stolen: false, date_stolen: nil }] }
    it 'returns hash' do
      expect(instance).to receive(:find_bikes_with_serial) { target_find_bikes_with_serial_response }
      expect(instance.create_bike_hashes_for_serial(serial)).to eq target
    end
  end
end
