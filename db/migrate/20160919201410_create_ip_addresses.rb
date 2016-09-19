class CreateIpAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :ip_addresses do |t|
      t.text :address
      t.float :latitude
      t.float :longitude
      t.datetime :started_being_inspector_at
      t.datetime :stopped_being_inspector_at

      t.timestamps
    end
  end
end
