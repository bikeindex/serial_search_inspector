class CreateLogLines < ActiveRecord::Migration[5.0]
  def change
    create_table :log_lines do |t|
      t.json :entry
      t.datetime :request_at
      t.string :search_source
      t.string :search_type
      t.boolean :insufficient_length
      t.boolean :inspector
      t.float :latitude
      t.float :longitude
      t.references :ip_address, index: true
      t.references :serial_search, index: true

      t.timestamps
    end
  end
end
