class UsersController < ApplicationController
  # before_action :authenticate_user!
  ## @user.update_attributesの内容がすぐに反映されなくなる… Ajax関係?

  def update
    p params
    @user = User.find(params[:id])
    @user.update_attributes(
      jobid: params[:user][:jobid] || @user[:jobid],
      setid: params[:user][:setid] || @user[:setid],
      lang:  params[:user][:lang]  || @user[:lang])
    render partial: 'layouts/gearset_partial'
  end

  private
  ## Never trust parameters from the scary internet, only allow the white list through.

  def user_params
     params.require(:user).permit(:id, :jobid, :setid, :lang)
  end
end
