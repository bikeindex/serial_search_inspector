class CheckBikeSerialSearchesJob < ApplicationJob
  queue_as :default

  def perform(bike, serial)
    serial_search = SerialSearch.find_by(serial: serial)

    if bike && serial_search
      bike_serial_search_attributes = {
        serial_search_id: serial_search.id,
        bike_id: bike.id
      }

      BikeSerialSearch.create(bike_serial_search_attributes)
    end
  end
end
