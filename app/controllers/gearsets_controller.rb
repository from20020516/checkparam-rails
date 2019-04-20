class GearsetsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update]
  before_action :set_current_gears, only: [:index, :create]

  # Fire when a Equipment changed with new set.
  def create
    Gearset.current_set(current_user).update(gearset_params)
  end

  # Fire when a Equipment chenged.
  def update
    Gearset.current_set(current_user).update(gearset_params)
  end

  def show
    @gearset = Gearset.find(params[:id])
  end

  def descriptions
    lang = JSON.parse(params.require(:lang)) || I18n.locale
    gears = JSON.parse(params.require(:id)).map(&:to_i)

    # TODO: remove "colon" in DB key name.
    stats_raw = Stat.current_stat(gears)
    stats = gears.map { |i| stats_raw[i]&.first&.attributes&.with_indifferent_access }.compact

    results = {
      descriptions: Item.where(id: gears).map { |item| [item.id, item.description[lang.to_sym]] }.to_h,
      checkparam: Stat.names.map { |key| [key, stats.pluck(key).compact.inject(:+)] }.to_h
      # TODO: use model scope.
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
