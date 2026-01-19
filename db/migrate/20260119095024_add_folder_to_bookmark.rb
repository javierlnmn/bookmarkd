class AddFolderToBookmark < ActiveRecord::Migration[8.1]
  def change
    add_reference :bookmarks, :folder, null: true, foreign_key: true
  end
end
