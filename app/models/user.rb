class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :folder_collaborations, dependent: :destroy
  has_many :collaborating_folders, through: :folder_collaborations, source: :folder

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
