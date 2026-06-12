class FoldersController < ApplicationController
  before_action :set_folder, only: %i[ show edit update destroy move move_form ]
  before_action :check_folder_owner, only: %i[ edit update destroy move move_form ]
  allow_unauthenticated_access only: %i[ show ]

  def index
    @folders = Current.user.folders.where parent_id: nil
    @bookmarks = Current.user.bookmarks.where folder_id: nil
  end

  def show
    if cookies[:session_id]
      require_authentication
    end

    if !Current.user.nil? and Current.user.id == @folder.user.id
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
    @folder = Current.user.folders.new folder_params

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
    if params[:browse_id]
      @browse_folder = Current.user.folders.find(params[:browse_id])
      @folders = @browse_folder.children.where.not(id: @folder.id)
      @at_root = false
    elsif params[:at_root]
      @browse_folder = nil
      @folders = Current.user.folders.where(parent_id: nil).where.not(id: @folder.id)
      @at_root = true
    elsif @folder.parent_id
      @browse_folder = Current.user.folders.find(@folder.parent_id)
      @folders = @browse_folder.children.where.not(id: @folder.id)
      @at_root = false
    else
      @browse_folder = nil
      @folders = Current.user.folders.where(parent_id: nil).where.not(id: @folder.id)
      @at_root = false
    end

    render :move, layout: "modal"
  end

  def move
    if params[:parent_id]
      new_folder = Folder.find(params[:parent_id])
      head :forbidden unless new_folder.user_id == Current.user.id
      @folder.update(parent_id: new_folder.id)
      redirect_to new_folder
    else
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

    def check_folder_owner
      head :forbidden unless @folder.user_id == Current.user.id
    end
end
