class AddTagsToBookmark < ActiveRecord::Migration[8.1]
  def change
    create_table :bookmarks_tags, id: false do |t|
      t.belongs_to :bookmark
      t.belongs_to :tag
    end
  end
end
