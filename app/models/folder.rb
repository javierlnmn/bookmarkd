class Folder < ApplicationRecord
  has_many :children, class_name: "Folder", foreign_key: "parent_id"
  belongs_to :parent, class_name: "Folder", optional: true
  has_many :bookmarks, dependent: :destroy
  belongs_to :user
  has_many :folder_collaborations, dependent: :destroy
  has_many :collaborators, through: :folder_collaborations, source: :user

  validates :name, presence: true
  validate :parent_belongs_to_user

  def owned_by?(user)
    user.present? && user.id == user_id
  end

  def collaborator?(user)
    return false if user.nil?
    collaborators.exists?(user.id) || !!parent&.collaborator?(user)
  end

  def editable_by?(user)
    owned_by?(user) || collaborator?(user)
  end

  # Nearest ancestor (or self) with a direct collaboration grant for `user` — the highest point they can see/move within.
  def collaboration_boundary_for(user)
    return nil if user.nil? || owned_by?(user)
    return self if collaborators.exists?(user.id)
    parent&.collaboration_boundary_for(user)
  end

  def self_and_descendants
    [ self ] + children.flat_map(&:self_and_descendants)
  end

  def get_path
    if self.parent
      if self.parent.is_public or editable_by?(Current.user)
        self.parent.get_path + [ self ]
      else
        [ self ]
      end
    else
      [ self ]
    end
  end

  def parent_belongs_to_user
    if parent
      errors.add(:base, "Please use a valid parent folder") unless parent.user_id == user_id
    end
  end
end
