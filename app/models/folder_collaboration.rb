class FolderCollaboration < ApplicationRecord
  belongs_to :folder
  belongs_to :user

  attr_accessor :email_address

  validates :user_id, uniqueness: { scope: :folder_id, message: "is already a collaborator on this folder" }
  validate :user_is_not_owner

  private
    def user_is_not_owner
      errors.add(:user, "is already the owner of this folder") if folder && user_id == folder.user_id
    end
end
