require 'rails_helper'

describe BikeIndexRequestor do
  let(:instance) { BikeIndexRequestor.new }
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
    }
  end
  describe 'find_bikes_with_serial' do
    let(:serial) { 'some number' }
    it 'searches by serial' do
      VCR.use_cassette('bike_index_requestor_find_bikes_with_serial') do
        expect(instance.find_bikes_with_serial(serial)).to eq target_find_bikes_with_serial_response.as_json
      end
    end
  end
  describe 'find_bike_hashes_for_serial' do
    # let(:target) { [ {id: 30080, etc}]}
    # expect to receive(find_bikes_with_serial) { target_find_bikes_with_serial_response }
  end
end
