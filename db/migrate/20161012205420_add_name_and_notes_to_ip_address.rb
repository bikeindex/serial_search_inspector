class AddNameAndNotesToIpAddress < ActiveRecord::Migration[5.0]
  def change
    add_column :ip_addresses, :name, :string
    add_column :ip_addresses, :notes, :text
  end
end
