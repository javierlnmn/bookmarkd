class TagsController < ApplicationController
  before_action :set_tag, only: %i[ edit update destroy ]
  before_action :check_tag_owner, only: %i[ edit update destroy ]

  def create
    @tag = Current.user.tags.new(tag_params)

    if @tag.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profile_path(tab: "tags") }
      end
    else
      render_profile_tags status: :unprocessable_entity
    end
  end

  def edit
    render :edit, layout: "modal"
  end

  def update
    if @tag.update tag_params
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to profile_path(tab: "tags") }
      end
    else
      render :edit, status: :unprocessable_entity, layout: "modal"
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to profile_path(tab: "tags") }
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

    def render_profile_tags(**options)
      @user = Current.user
      @tags = Current.user.tags.order(:name)
      @active_tab = "tags"
      render "profiles/show", **options
    end
end
