class AddThumbnailToBookmark < ActiveRecord::Migration[8.1]
  def change
    add_column :bookmarks, :thumbnail, :string
  end
end
