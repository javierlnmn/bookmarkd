class CreateFolderCollaborations < ActiveRecord::Migration[8.1]
  def change
    create_table :folder_collaborations do |t|
      t.references :folder, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :folder_collaborations, [ :folder_id, :user_id ], unique: true
  end
end
