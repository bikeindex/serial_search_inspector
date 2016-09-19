class CreateLogLines < ActiveRecord::Migration[5.0]
  def change
    create_table :log_lines do |t|
      t.json :entry
      t.datetime :request_at
      t.string :source
      t.string :source
      t.boolean :insufficient_length
      t.boolean :inspector
      t.float :latitude
      t.float :longitude
      t.references :ip_address
      t.references :serial

      t.timestamps
    end
  end
end
