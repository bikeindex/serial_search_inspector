require './lib/bike_index'

class FetchBikeIndexBikesJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.update_attribute(:binx_bikes, BikeIndex::Requester.new(user).request_bikes)

    user.binx_bikes['bikes'].each do |bike|
      bike_attributes = {
        user_id: user.id,
        bike_index_id: bike['id'],
        title: bike['title'],
        serial: bike['serial']
      }
      Bike.find_or_create_by(bike_attributes)

      CheckBikeSerialSearchesJob.perform_later(bike['serial'])
    end
  end
end
