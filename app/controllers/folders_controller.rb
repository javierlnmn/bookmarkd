class FoldersController < ApplicationController
  def index
    @folders = Folder.all
    @bookmarks = Bookmark.where folder_id: nil
  end
  def new
  end
  def create
  end
  def edit
  end
  def update
  end
end
