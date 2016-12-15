class RecreateBikeSerialSearchesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :bikes_serial_searches

    create_table :bike_serial_searches do |t|
      t.references :bike
      t.references :serial_search

      t.timestamps
    end
  end
end
