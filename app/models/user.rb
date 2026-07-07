class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :folder_collaborations, dependent: :destroy
  has_many :collaborating_folders, through: :folder_collaborations, source: :folder

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def editable_bookmarks
    Bookmark.where(user_id: id).or(Bookmark.where(folder_id: shared_folder_ids))
  end

  def shared_folder_ids
    @shared_folder_ids ||= collaborating_folders.flat_map { |folder| folder.self_and_descendants.map(&:id) }.uniq
  end

  def shared_folders_count
    shared_folder_ids.size
  end

  def shared_bookmarks_count
    Bookmark.where(folder_id: shared_folder_ids).count
  end

  def destroy_all_data!
    transaction do
      bookmarks.destroy_all
      folders.update_all(parent_id: nil)
      folders.destroy_all
      tags.destroy_all
      folder_collaborations.destroy_all
    end
  end
end
