class RemoveDefaultUserFromBookmarkAndFolder < ActiveRecord::Migration[8.1]
  def change
    change_column_default :bookmarks, :user_id, from: 1, to: nil
    change_column_default :folders, :user_id, from: 1, to: nil
  end
end
