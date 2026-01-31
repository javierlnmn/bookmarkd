class Bookmark < ApplicationRecord
  belongs_to :folder, optional: true
  belongs_to :user

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI.regexp }
  validate :folder_belongs_to_user

  def folder_belongs_to_user
    if folder
      errors.add(:base, "Please, use a valid folder") unless folder.user_id == user_id
    end
  end
end
