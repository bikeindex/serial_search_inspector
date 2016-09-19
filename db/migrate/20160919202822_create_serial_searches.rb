class CreateSerialSearches < ActiveRecord::Migration[5.0]
  def change
    create_table :serial_searches do |t|
      t.text :serial
      t.datetime :searched_bike_index_at
      t.boolean :too_many_results

      t.timestamps
    end
  end
end
