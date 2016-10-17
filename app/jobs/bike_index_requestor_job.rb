class BikeIndexRequestorJob < ApplicationJob
  queue_as :default

  def perform(serial_search)
    bike_array = BikeIndexRequestor.new.create_bike_hashes_for_serial(serial_search)
    Bike.find_or_create_bikes_from_bike_array(bike_array)
  end
end
