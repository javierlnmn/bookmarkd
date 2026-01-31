class FoldersController < ApplicationController
  before_action :set_folder, only: %i[ show edit update destroy ]

  def index
    @folders = Current.user.folders.where parent_id: nil
    @bookmarks = Current.user.bookmarks.where folder_id: nil
  end

  def show
    @folders = @folder.children
    @bookmarks = @folder.bookmarks
  end

  def new
    @folder = Folder.new(parent_id: params[:folder_id])
    render :new, layout: "modal"
  end

  def create
    @folder = Current.user.folders.new folder_params

    if @folder.save()
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

  private
    def set_folder
      @folder = Current.user.folders.find(params[:id])
    end

    def folder_params
      params.expect(folder: [ :name, :url, :parent_id ])
    end
end
