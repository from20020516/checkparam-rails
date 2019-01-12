class GearsetsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :update]
  before_action :gearset_params

  def index
  end

  def update # Fire when a equipment chenged.
    @gearset.update_attributes(gearset_params)
  end

  def show
    @viewset = Gearset.find(params[:id])
  end

  def about
  end

  private

  def gearset_params
    if current_user.present?
      @gearset = Gearset.find_or_create_by(user_id: current_user.id, jobid: current_user.jobid, setid: current_user.setid)
      params.require(:gearset).permit(
        :id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet) if params[:gearset].present?
    end
  end
end