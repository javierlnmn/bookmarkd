class BookmarksController < ApplicationController
  before_action :set_bookmark, only: %i[ edit update destroy tag untag move move_form ]
  before_action :check_bookmark_editable, only: %i[ edit update destroy tag untag move move_form ]

  def new
    @bookmark = Bookmark.new(folder_id: params[:folder_id])
    render :new, layout: "modal"
  end

  def create
    owner = Current.user

    if bookmark_params[:folder_id].present?
      folder = Folder.find(bookmark_params[:folder_id])
      return head :forbidden unless folder.is_owner_or_collaborator?(Current.user)
      owner = folder.user
    end

    @bookmark = owner.bookmarks.new(bookmark_params)

    if @bookmark.save
      @bookmark.update_thumbnail

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
    if bookmark_params[:folder_id].present? && bookmark_params[:folder_id].to_i != @bookmark.folder_id
      new_folder = Folder.find(bookmark_params[:folder_id])
      return head :forbidden unless new_folder.is_owner_or_collaborator?(Current.user)
    end

    if @bookmark.update(bookmark_params)
      @bookmark.update_thumbnail

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

  def move_form
    if @bookmark.owned_by?(Current.user)
      @collaboration_boundary = nil
      allowed_folders = @bookmark.user.folders
    else
      @collaboration_boundary = @bookmark.folder.collaboration_boundary_for(Current.user)
      allowed_folders = Folder.where(id: @collaboration_boundary.self_and_descendants.map(&:id))
    end

    if params[:browse_id]
      @browse_folder = allowed_folders.find(params[:browse_id])
    elsif params[:at_root]
      @browse_folder = @collaboration_boundary
    elsif @bookmark.folder_id && @bookmark.folder_id != @collaboration_boundary&.id
      @browse_folder = allowed_folders.find(@bookmark.folder_id)
    else
      @browse_folder = @collaboration_boundary
    end

    @folders = @browse_folder ? @browse_folder.children : allowed_folders.where(parent_id: nil)
    @at_root = @browse_folder&.id == @collaboration_boundary&.id
    @browse_is_self = false

    render :move, layout: "modal"
  end

  def move
    if params[:folder_id]
      new_folder = @bookmark.user.folders.find(params[:folder_id])
      return head :forbidden unless new_folder.is_owner_or_collaborator?(Current.user)
      @bookmark.update(folder_id: new_folder.id)
      redirect_to new_folder
    else
      return head :forbidden unless @bookmark.owned_by?(Current.user)
      @bookmark.update(folder_id: nil)
      redirect_to folders_path
    end
  end

  def tag
    @tag = Current.user.tags.find params[:tag_id]

    if @bookmark.tags.exists? @tag.id
      head :bad_request
    else
      @bookmark.tags<< @tag
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  def untag
    @tag = Current.user.tags.find params[:tag_id]

    if @bookmark.tags.include? @tag
      @bookmark.tags.delete @tag
    end

    respond_to do |format|
      format.turbo_stream
    end
  end

  private
    def bookmark_params
      params.expect(bookmark: [ :name, :description, :url, :folder_id ])
    end

    def set_bookmark
      @bookmark = Bookmark.find(params[:id])
    end

    def check_bookmark_editable
      head :forbidden unless @bookmark.editable_by?(Current.user)
    end
end
