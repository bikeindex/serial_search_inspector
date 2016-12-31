class CreateUserBikes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_bikes do |t|
      t.references :user_id
      t.references :bike_id

      t.timestamps
    end
  end
end
