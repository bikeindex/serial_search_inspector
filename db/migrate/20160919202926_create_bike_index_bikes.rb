class CreateBikeIndexBikes < ActiveRecord::Migration[5.0]
  def change
    create_table :bike_index_bikes do |t|
      t.integer :bike_index_id
      t.boolean :stolen
      t.datetime :date_stolen
      t.references :serial_search

      t.timestamps
    end
  end
end
