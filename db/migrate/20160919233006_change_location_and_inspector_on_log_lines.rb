class ChangeLocationAndInspectorOnLogLines < ActiveRecord::Migration[5.0]
  def change
    change_table :log_lines do |t|
      t.remove :longitude
      t.rename :latitude, :entry_location
      t.rename :inspector, :inspector_request
    end
    change_column :log_lines, :entry_location, :string
  end
end
