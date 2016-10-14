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
end
