class AddLastReqestAtToSerialSearches < ActiveRecord::Migration[5.0]
  def change
    add_column :serial_searches, :last_request_at, :datetime
  end
end
