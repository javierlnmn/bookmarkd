class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.where(folder_id: nil)
    puts @bookmarks
  end

  def new
    @bookmark = Bookmark.new
    render "_form"
  end

  def create
    @bookmark = Bookmark.new(bookmark_params())
    if @bookmark.save
      redirect_to bookmarks_path
    else
      render :new
    end
  end

  private

    def bookmark_params
      params.expect(bookmark: [ :name, :url ])
    end
end
