class GearsetsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :set_current_gears, only: [:index, :create]

  # Fire when a Equipment changed with new set.
  def create
    Gearset.current(current_user).update(gearset_params)
  end

  # Fire when a Equipment chenged.
  def update
    Gearset.current(current_user).update(gearset_params)
  end

  def show
    @gearset = Gearset.find(params[:id])
  end

  def descriptions
    # lang = JSON.parse(params.require(:lang)) || I18n.locale
    ids = JSON.parse(params.require(:id)).map(&:to_i)
    results = {
      descriptions: Item.current(ids).pluck(:id).zip(Item.current(ids).pluck(:description).pluck(I18n.locale)).to_h,
      checkparam: Stat.checkparam(ids)
    }
    render json: results
  end

  def set_current_gears
    @current_gears = Item.current_job(current_user.job_id, current_user.lang) if user_signed_in?
  end

  private

  def gearset_params
    if current_user.present?
      params.require(:gearset).permit(:id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet) if params[:gearset].present?
    end
  end
end
