class AddGeocoderFieldsToIpAddress < ActiveRecord::Migration[5.0]
  def change
    remove_column :ip_addresses, :location, :string
    add_column  :ip_addresses, :city, :string
    add_column  :ip_addresses, :state, :string
    add_column  :ip_addresses, :country, :string
  end
end
