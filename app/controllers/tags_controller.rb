class TagsController < ApplicationController
  before_action :set_tag, only: %i[ edit update destroy ]
  before_action :check_tag_owner, only: %i[ edit update destroy ]

  def index
    @tags = Current.user.tags.order(:name)
    @tag = Tag.new

    render :index, layout: "modal"
  end

  def create
    @tag = Current.user.tags.new(tag_params)

    if @tag.save
      respond_to do | format |
        format.turbo_stream
      end
    else
      render :index, status: :unprocessable_entity, layout: "modal"
    end
  end

  def edit
    render :edit, layout: "modal"
  end

  def update
    if @tag.update tag_params
      redirect_to tags_path
    else
      render :index, status: :unprocessable_entity, layout: "modal"
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path
  end

  private
    def tag_params
      params.expect(tag: [ :name, :color ])
    end

    def set_tag
      @tag = Current.user.tags.find(params[:id])
    end

    def check_tag_owner
      head :forbidden unless @tag.user_id == Current.user.id
    end
end
