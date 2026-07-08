class FoldersController < ApplicationController
  before_action :set_folder, only: %i[ show edit update destroy move move_form ]
  before_action :check_folder_editable, only: %i[ edit update destroy move move_form ]
  allow_unauthenticated_access only: %i[ show ]

  def index
    @folders = Current.user.folders.where parent_id: nil
    @bookmarks = Current.user.bookmarks.where folder_id: nil
  end

  def show
    if cookies[:session_id]
      require_authentication
    end

    if @folder.is_owner_or_collaborator?(Current.user)
      @folders = @folder.children
    elsif @folder.is_public?
      @folders = @folder.children.where(is_public: true)
    else
      if Current.user.nil?
        redirect_to new_session_path
      else
        redirect_to folders_path
      end
    end

    @bookmarks = @folder.bookmarks
  end

  def new
    @folder = Folder.new(parent_id: params[:folder_id])
    render :new, layout: "modal"
  end

  def create
    owner = Current.user

    if folder_params[:parent_id].present?
      parent = Folder.find(folder_params[:parent_id])
      return head :forbidden unless parent.is_owner_or_collaborator?(Current.user)
      owner = parent.user
    end

    @folder = owner.folders.new folder_params

    if @folder.save
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
    if folder_params[:parent_id].present? && folder_params[:parent_id].to_i != @folder.parent_id
      new_parent = @folder.user.folders.find(folder_params[:parent_id])
      return head :forbidden unless new_parent.is_owner_or_collaborator?(Current.user)
    end

    if @folder.update(folder_params)
      redirect_to @folder.parent || folders_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    parent = @folder.parent
    @folder.destroy
    redirect_to parent || folders_path
  end

  def move_form
    if @folder.owned_by?(Current.user)
      @collaboration_boundary = nil
      allowed_folders = @folder.user.folders
    else
      @collaboration_boundary = @folder.collaboration_boundary_for(Current.user)
      allowed_folders = Folder.where(id: @collaboration_boundary.self_and_descendants.map(&:id))
    end

    excluded_ids = @folder.self_and_descendants.map(&:id)

    if params[:browse_id]
      @browse_folder = allowed_folders.find(params[:browse_id])
    elsif params[:at_root]
      @browse_folder = @collaboration_boundary
    elsif @folder.parent_id && @folder.id != @collaboration_boundary&.id
      @browse_folder = allowed_folders.find(@folder.parent_id)
    else
      @browse_folder = @collaboration_boundary
    end

    @folders = (@browse_folder ? @browse_folder.children : allowed_folders.where(parent_id: nil)).where.not(id: excluded_ids)
    @at_root = @browse_folder&.id == @collaboration_boundary&.id
    @browse_is_self = @browse_folder&.id == @folder.id

    render :move, layout: "modal"
  end

  def move
    if params[:parent_id]
      new_folder = @folder.user.folders.find(params[:parent_id])
      return head :forbidden unless new_folder.is_owner_or_collaborator?(Current.user)
      return head :forbidden if @folder.self_and_descendants.map(&:id).include?(new_folder.id)
      @folder.update(parent_id: new_folder.id)
      redirect_to new_folder
    else
      return head :forbidden unless @folder.owned_by?(Current.user)
      @folder.update(parent_id: nil)
      redirect_to folders_path
    end
  end

  private
    def folder_params
      params.expect(folder: [ :name, :description, :url, :parent_id, :is_public ])
    end

    def set_folder
      @folder = Folder.find(params[:id])
    end

    def check_folder_editable
      head :forbidden unless @folder.editable_by?(Current.user)
    end
end
