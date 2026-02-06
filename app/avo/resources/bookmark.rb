class Avo::Resources::Bookmark < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: q, m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :description, as: :textarea
    field :url, as: :text
    field :folder_id, as: :number
    field :user_id, as: :number
    field :folder, as: :belongs_to
    field :user, as: :belongs_to
    field :tags, as: :has_and_belongs_to_many
  end
end
