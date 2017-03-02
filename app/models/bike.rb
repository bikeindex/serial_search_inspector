class Bike < ApplicationRecord
  validates_presence_of :bike_index_id
  validates_uniqueness_of :bike_index_id

  belongs_to :user, optional: true
  has_many :bike_serial_searches
  has_many :serial_searches, -> { distinct }, through: :bike_serial_searches

  def update_was_stolen
    self.was_stolen = true if stolen == true
  end

  def self.find_or_create_bikes_from_bike_array(bike_array)
    bike_array.each do |bike_attributes|
      bike = Bike.find_or_create_by(bike_index_id: bike_attributes[:bike_index_id])
      bike.update_attributes(bike_attributes)
      bike.update_was_stolen

      serial_search = SerialSearch.find_by(serial: bike.serial)

      if bike && serial_search
        BikeSerialSearch.create(bike_id: bike.id, serial_search_id: serial_search.id)
      end
    end
  end
end
