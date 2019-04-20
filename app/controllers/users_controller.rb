class UsersController < ApplicationController
  before_action :authenticate_user!

  # Fire when job/set changed.
  def update
    current_user.update(user_params)
    @current_gears = Item.current_job(current_user.job_id, current_user.lang)
    render partial: 'layouts/gearset_partial', locals: { current_user: current_user, lang: current_user.lang.to_sym }
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
