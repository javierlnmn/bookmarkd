class Avo::Resources::Folder < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :parent_id, as: :number
    field :user_id, as: :number
    field :is_public, as: :boolean
    field :children, as: :has_many
    field :parent, as: :belongs_to
    field :bookmarks, as: :has_many
    field :user, as: :belongs_to
  end
end
