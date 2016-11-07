class BikeIndexRequestorJob < ApplicationJob
  queue_as :default
  require 'BikeIndexRequestor'

  def perform(serial_search)
    if serial_search.valid_serial_search_for_bike_creation?
      serial_search.update_attribute(:searched_bike_index_at, DateTime.now)
      bike_array = BikeIndexRequestor.new.create_bike_hashes_for_serial(serial_search)
      Bike.find_or_create_bikes_from_bike_array(bike_array)
    end
  end
end
