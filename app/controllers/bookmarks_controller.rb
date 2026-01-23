class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.where(folder_id: nil)
    puts @bookmarks
  end

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

  private

    def bookmark_params
      params.expect(bookmark: [ :name, :url ])
    end
end
