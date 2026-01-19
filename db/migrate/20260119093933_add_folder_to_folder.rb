class AddFolderToFolder < ActiveRecord::Migration[8.1]
  def change
    add_reference :folders, :parent, null: true, foreign_key: { to_table: :folders }
  end
end
