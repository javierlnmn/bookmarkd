class AddPublicToFolder < ActiveRecord::Migration[8.1]
  def change
    add_column :folders, :is_public, :boolean, default: false
  end
end
