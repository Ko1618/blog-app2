class ProfilesController < ApplicationController
before_action :authenticate_user!

  def show
    @profile = current_user.profile
  end

  def edit
    #if current_user.profile.present?
    #  @profile = current_user.profile
    #else
    #  @profile = current_user.build_profile
    #has_oneの場合
    @profile = current_user.prepare_profile
  end

  def update
    @profile = current_user.prepare_profile
    @profile.assign_attributes(profile_params)
    if @profile.save
      redirect_to profile_path, notice: 'プロフィールを更新しました'
    else
      flash.now[:error] = '更新に失敗しました'
      render :edit
    end
  end

  private
  def profile_params
    params.require(:profile).permit(
      :nickname,
      :introduction,
      :gender,
      :birthday,
      :subscribed,
      :avatar
    )
  end
end
