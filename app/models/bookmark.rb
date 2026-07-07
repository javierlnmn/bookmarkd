class Bookmark < ApplicationRecord
  belongs_to :folder, optional: true
  belongs_to :user
  has_and_belongs_to_many :tags

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI.regexp }
  validate :folder_belongs_to_user

  def folder_belongs_to_user
    if folder
      errors.add(:base, "Please, use a valid folder") unless folder.user_id == user_id
    end
  end

  def editable_by?(user)
    return false if user.nil?
    folder ? folder.is_owner_or_collaborator?(user) : user.id == user_id
  end

  def update_thumbnail
    begin
      thumbnail = LinkThumbnailer.generate(self.url)
      self.thumbnail = thumbnail.images.first.src if thumbnail.images.any?
      self.save
    rescue LinkThumbnailer::Exceptions
    end
  end
end
