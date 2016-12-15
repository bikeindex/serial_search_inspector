class RemoveUserBikesTableAddUserIdToBike < ActiveRecord::Migration[5.0]
  def change
    drop_table :user_bikes

    add_reference :bikes, :user, index: true
    add_foreign_key :bikes, :users
  end
end
