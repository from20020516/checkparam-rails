class UsersController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!

  # Fire when job/set changed.
  def update
    current_user.update(user_params)

    if user_params.include?(:lang)
      I18n.locale = current_user.lang.to_sym
      respond_to do |format|
        format.js { render inline: 'location.reload();' }
      end
    else
      render partial: 'layouts/gearset_partial', locals: { current_user: current_user }
    end
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
