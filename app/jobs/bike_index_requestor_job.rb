class BikeIndexRequestorJob < ApplicationJob
  queue_as :default

  def perform(serial_search)
    if serial_search.searched_bike_index_at.nil? || !serial_search.within_min_request_time
      serial_search.update_attribute(:searched_bike_index_at, DateTime.now)
      bike_array = BikeIndexRequestor.new.create_bike_hashes_for_serial(serial_search)
      Bike.find_or_create_bikes_from_bike_array(bike_array)
    end
  end
end
