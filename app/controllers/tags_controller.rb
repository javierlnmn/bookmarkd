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
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to tags_redirect_path }
      end
    else
      render_tags_form status: :unprocessable_entity
    end
  end

  def edit
    render :edit, layout: "modal"
  end

  def update
    if @tag.update tag_params
      redirect_to tags_path
    else
      render_tags_form status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tags_redirect_path }
    end
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

    def profile_context?
      request.referer&.include?("/profile")
    end

    def tags_redirect_path
      profile_context? ? profile_path(tab: "tags") : tags_path
    end

    def render_tags_form(**options)
      @tags = Current.user.tags.order(:name)

      if profile_context?
        @user = Current.user
        @active_tab = "tags"
        render "profiles/show", **options
      else
        render :index, layout: "modal", **options
      end
    end
end
