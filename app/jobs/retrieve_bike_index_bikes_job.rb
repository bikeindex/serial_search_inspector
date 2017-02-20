require './lib/bike_index/requester' # why doesn't this get linked up automagically?

class RetrieveBikeIndexBikesJob < ApplicationJob
  queue_as :default

  def perform(user)
    user.binx_bikes = BikeIndex::Requester.new(user).get_bikes

    user.binx_bikes['bikes'].each do |bike|
      bike_attributes = {
        bike_index_id: bike['id'],
        title: bike['title'],
        serial: bike['serial']
      }
      new_bike = Bike.find_or_create_by(bike_attributes)

      user_bike_attributes = { bike_id: new_bike.id, user_id: user.id }
      UserBike.find_or_create_by(user_bike_attributes)

      CheckForBikeSerialSearchesJob.perform_later(bike['serial'])
    end
  end
end
