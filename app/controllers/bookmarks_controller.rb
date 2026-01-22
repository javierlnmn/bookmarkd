class BookmarksController < ApplicationController
  def index
    @bookmarks = Bookmark.where(folder_id: nil)
    puts @bookmarks
  end
end
