require './lib/bike_index'

class FetchBikeIndexBikesJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.update_attribute(:binx_bikes, BikeIndex::Requester.new(user).request_bikes)

    user.binx_bikes['bikes'].each do |bike|
      bike = Bike.find_or_create_by(bike_index_id: bike['id'])

      bike_attributes = {
        user_id: user.id,
        title: bike['title'],
        serial: bike['serial'],
        stolen: bike['stolen'],
        date_stolen: bike['date_stolen'] && Time.at(bike['date_stolen'])
      }

      bike.update_attributes(bike_attributes)
      bike.update_was_stolen

      CheckBikeSerialSearchesJob.perform_later(bike, bike['serial'])
    end
  end
end
