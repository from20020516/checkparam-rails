class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  # Fire when job/set changed.
  def update
    current_user.update(user_params)
    session[:lang] = current_user.lang
    I18n.locale = current_user.lang
    render partial: 'layouts/gearset_partial' # Refresh #{current_user} on partial.
  end

  def destroy
    current_user.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:id, :job_id, :set_id, :lang) if params[:user].present?
  end
end