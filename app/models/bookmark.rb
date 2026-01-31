class Bookmark < ApplicationRecord
  belongs_to :folder, optional: true
  belongs_to :user

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI.regexp }
end
