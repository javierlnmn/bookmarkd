class Avo::Resources::Tag < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :color, as: :text
    field :user_id, as: :number
    field :user, as: :belongs_to
    field :bookmarks, as: :has_and_belongs_to_many
  end
end
