class RemoveSerialSearchIdFromBikes < ActiveRecord::Migration[5.0]
  def change
    remove_column :bikes, :serial_search_id
  end
end
