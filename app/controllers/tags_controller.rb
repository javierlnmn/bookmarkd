class TagsController < ApplicationController
  before_action :set_tag, only: %i[ edit update destroy ]
  before_action :check_tag_owner, only: %i[ edit update destroy ]

  def index
    @tags = Current.user.tags.order(:name)
    render :index, layout: "modal"
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def tag_params
      params.expect(tag: [ :name, :description, :url, :folder_id ])
    end

    def set_tag
      @tag = Current.user.tags.find(params[:id])
    end

    def check_tag_owner
      head :forbidden unless @tag.user_id == Current.user.id
    end
end
