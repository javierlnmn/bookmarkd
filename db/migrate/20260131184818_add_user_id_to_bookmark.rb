class AddUserIdToBookmark < ActiveRecord::Migration[8.1]
  def change
    add_reference :bookmarks, :user, null: false, default: 1, foreign_key: true
    add_reference :folders, :user, null: false, default: 1, foreign_key: true
  end
end
