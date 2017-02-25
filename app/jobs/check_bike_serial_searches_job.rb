class CheckBikeSerialSearchesJob < ApplicationJob
  queue_as :default

  def perform(serial)
    bikes = Bike.where(serial: serial)
    serial_search = SerialSearch.find_by(serial: serial)

    if bikes && serial_search
      bikes.each do |bike|
        bike_serial_search_attributes = {
          serial_search_id: serial_search.id,
          bike_id: bike.id
        }

        BikeSerialSearch.create(bike_serial_search_attributes)
      end
    end
  end
end
