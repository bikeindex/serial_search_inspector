class CreateBikesSerialSearchesTable < ActiveRecord::Migration[5.0]
  def change
    create_table :bikes_serial_searches do |t|
      t.belongs_to :bike, index: true
      t.belongs_to :serial_search, index: true
    end
  end
end
