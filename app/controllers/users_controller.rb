class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_action :user_params
  before_action :active_user

  # Fire when job/set changed.
  def update
    @user.update_attributes(user_params)
    @items = Item.where('job & ? > 0', 2**@user.job_id).order(@user.lang)
    Gearset.find_or_create_by(user_id: @user.id, job_id: @user.job_id, index: @user.index)
    render partial: 'layouts/gearset_partial', locals: {current_user: @user} # Refresh #{current_user} on partial.
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private

  def active_user
    @user = User.find(current_user.id)
  end

  def user_params
    return params.require(:user).permit(:id, :job_id, :index, :lang) if params[:user].present?
  end
end