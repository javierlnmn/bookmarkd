class ProfilesController < ApplicationController
  def show
    @user = Current.user
    @active_tab = params[:tab].presence_in(%w[ stats session ]) || "stats"
  end

  def update
    @user = Current.user
    @active_tab = "session"

    unless @user.authenticate(password_params[:current_password].to_s)
      flash.now[:alert] = "Current password is incorrect."
      return render :show, status: :unprocessable_entity
    end

    if @user.update(
      password: password_params[:password],
      password_confirmation: password_params[:password_confirmation]
    )
      redirect_to profile_path(tab: "session"), notice: "Password updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  def destroy_data
    @user = Current.user

    unless @user.authenticate(destroy_data_params[:password].to_s)
      redirect_to profile_path(tab: "stats"), alert: "Password is incorrect."
      return
    end

    @user.destroy_all_data!
    redirect_to profile_path(tab: "stats"), notice: "All your data has been deleted."
  end

  private
    def password_params
      params.expect(profile: [ :current_password, :password, :password_confirmation ])
    end

    def destroy_data_params
      params.expect(profile: [ :password ])
    end
end
