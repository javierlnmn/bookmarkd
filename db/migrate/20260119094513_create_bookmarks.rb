class CreateBookmarks < ActiveRecord::Migration[8.1]
  def change
    create_table :bookmarks do |t|
      t.string :name
      t.string :description
      t.string :url

      t.timestamps
    end
  end
end
