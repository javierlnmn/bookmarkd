class FolderCollaborationsController < ApplicationController
  before_action :set_folder, except: :index
  before_action :check_folder_owner, except: :index

  def index
    @folders = Current.user.collaborating_folders.includes(:user).order(:name)
  end

  def new
    @folder_collaboration = FolderCollaboration.new(folder: @folder)
    render :new, layout: "modal"
  end

  def create
    email_address = params.dig(:folder_collaboration, :email_address)
    collaborator = User.find_by(email_address: email_address)

    if collaborator.nil?
      flash.now[:notice] = "No user found with that email"
      @folder_collaboration = FolderCollaboration.new(folder: @folder, email_address: email_address)
      render :new, layout: "modal"
      return
    end

    @folder_collaboration = FolderCollaboration.new(folder: @folder, user: collaborator)

    if @folder_collaboration.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @folder }
      end
    else
      render :new, status: :unprocessable_entity, layout: "modal"
    end
  end

  def destroy
    @folder_collaboration = @folder.folder_collaborations.find(params[:id])
    @folder_collaboration.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @folder }
    end
  end

  private
    def set_folder
      @folder = Folder.find(params[:folder_id])
    end

    def check_folder_owner
      head :forbidden unless @folder.owned_by?(Current.user)
    end
end
