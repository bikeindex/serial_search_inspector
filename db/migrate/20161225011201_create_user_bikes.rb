class CreateUserBikes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_bikes do |t|
      t.references :user
      t.references :bike

      t.timestamps
    end
  end
end
