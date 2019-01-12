class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_params

  def update # Fire when job/set changed.
    @user.update_attributes(jobid: params[:user][:jobid] || @user[:jobid], setid: params[:user][:setid] || @user[:setid], lang:  params[:user][:lang]  || @user[:lang])
    Gearset.find_or_create_by(user_id: @user.id, jobid: @user.jobid, setid: @user.setid)
    render partial: 'layouts/gearset_partial', locals: {current_user: @user} # Enable and refresh #{current_user} variable on partial.
  end

  def destroy
    @user.destroy
    redirect_to root_path
  end

  private

  def user_params
    @user = User.find(current_user.id)
    params.require(:user).permit(:id, :jobid, :setid, :lang) if params[:user].present?
  end
end