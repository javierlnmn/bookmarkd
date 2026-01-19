class CreateFolders < ActiveRecord::Migration[8.1]
  def change
    create_table :folders do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
