class GearsetsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: [:create, :update]

  # Fire when a Equipment changed with new set.
  def create
    gearset.update(gearset_params)
  end

  # Fire when a Equipment chenged.
  def update
    gearset.update(gearset_params)
  end

  def show
    @gearset = Gearset.find(params[:id])
  end

  def descriptions
    gears = JSON.parse(ajax_params).map(&:to_i)
    stats = Stat.where(item_id: gears).group_by(&:item_id)
    stats = gears.map { |i| stats[i][0].attributes.with_indifferent_access if stats[i].present? }.compact
    results = {
      descriptions: Item.where(id: gears).map { |item| [item.id, item.description[I18n.locale.to_s]] }.to_h,
      checkparam: stat_columns.map { |stat_name| [stat_name, stats.pluck(stat_name).compact.inject(:+)] }.to_h
    }
    render json: results
  end

  private

  def gearset_params
    if current_user.present?
      return params.require(:gearset).permit(:id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet) if params[:gearset].present?
    end
  end

  def ajax_params
    return params.require(:id)
  end
end
