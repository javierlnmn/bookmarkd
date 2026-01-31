class Folder < ApplicationRecord
  has_many :children, class_name: "Folder", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Folder", optional: true
  has_many :bookmarks, dependent: :destroy
  belongs_to :user

  validates :name, presence: true

  def get_path
    if self.parent
      self.parent.get_path + [ self ]
    else
      [ self ]
    end
  end
end
