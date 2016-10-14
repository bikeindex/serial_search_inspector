class BikeIndexRequestor
  include HTTParty
  base_uri 'https://bikeindex.org/api/v3'

  def find_bikes_with_serial(serial)
    options = {
      query: {
        per_page: 100,
        serial: serial,
        stolenness: 'all'
      }
    }
    response = self.class.get('/search', options)
    JSON.parse(response.body)
  end

  def create_bike_hashes_for_serial(serial)
    find_bikes_with_serial(serial)['bikes'].map do |bike|
      {
        bike_index_id: bike['id'],
        stolen: bike['stolen'],
        date_stolen: bike['date_stolen']
      }
    end
  end
end
