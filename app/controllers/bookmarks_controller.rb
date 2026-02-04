class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ edit update destroy ]
  before_action :check_bookmark_owner, only: %i[ edit update destroy ]

  def new
    @bookmark = Bookmark.new(folder_id: params[:folder_id])
    render :new, layout: "modal"
  end

  def create
    @bookmark = Current.user.bookmarks.new(bookmark_params)

    if @bookmark.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to folders_path }
      end
    else
      render :new, status: :unprocessable_entity, layout: "modal"
    end
  end

  def edit
    render :edit, layout: "modal"
  end

  def update
    if @bookmark.update(bookmark_params)
      redirect_to @bookmark.folder || folders_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    folder = @bookmark.folder
    @bookmark.destroy
    redirect_to folder || folders_path
  end

  def tag
    @bookmark = Current.user.bookmarks.find params[:id]
    @tag = Current.user.tags.find params[:tag_id]

    @bookmark.tags<< @tag

    respond_to do |format|
      format.turbo_stream
    end
  end

  def remove_tag
  end

  private
    def bookmark_params
      params.expect(bookmark: [ :name, :description, :url, :folder_id ])
    end

    def set_bookmark
      @bookmark = Current.user.bookmarks.find(params[:id])
    end

    def check_bookmark_owner
      head :forbidden unless @bookmark.user_id == Current.user.id
    end
end
