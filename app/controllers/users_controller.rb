class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!
  before_action :user_params

  # Fire when job/set changed.
  def update
    user.update_attributes(user_params)
    render partial: 'layouts/gearset_partial' # Refresh #{current_user} on partial.
  end

  def destroy
    user.destroy
    redirect_to root_path
  end

  private

  def user_params
    return params.require(:user).permit(:id, :job_id, :index, :lang) if params[:user].present?
  end
end