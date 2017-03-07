require './lib/bike_index'

class FetchBikeByBikeIndexIdJob < ApplicationJob
  queue_as :default

  def perform(bike)
    response = BikeIndex::Requester.new.request_bike_by_bike_index_id(bike.bike_index_id)

    bike_attributes = {
      serial: response['bike']['serial'],
      title: response['bike']['title']
    }

    bike.update_attributes(bike_attributes)
  end
end
