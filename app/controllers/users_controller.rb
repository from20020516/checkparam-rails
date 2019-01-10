class UsersController < ApplicationController
  def update
    @user = User.find(params[:id])
    @user.update_attributes(
      jobid: params[:user][:jobid] || @user[:jobid],
      setid: params[:user][:setid] || @user[:setid],
      lang:  params[:user][:lang]  || @user[:lang])
    render partial: 'layouts/gearset_partial'
  end

  private

  def user_params
     params.require(:user).permit(:id, :jobid, :setid, :lang)
  end
end
