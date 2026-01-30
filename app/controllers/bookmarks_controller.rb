class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ edit update destroy ]

  def new
    @bookmark = Bookmark.new
    render :new, layout: "modal"
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)

    if @bookmark.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to bookmarks_path }
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

  private
    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    def bookmark_params
      params.expect(bookmark: [ :name, :url ])
    end
end
