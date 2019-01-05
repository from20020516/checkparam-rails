class HomeController < ApplicationController

  def index
  end

  def about
  end

  def update
    @user = User.find(current_user.id)
    @user.update_attributes(jobid: params[:jobid] || @user[:jobid], lang: params[:lang] || @user[:lang])
    current_user.update_attributes(jobid: @user[:jobid], lang: @user[:lang])

    render partial: 'equipset_partial'
  end
end