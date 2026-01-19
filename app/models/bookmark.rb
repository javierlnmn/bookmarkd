class Bookmark < ApplicationRecord
  belongs_to :folder, optional: true
end
