include Common
class GearsetsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: [:create, :update, :descriptions]

  def index
  end

  # Fire when a Equipment changed with new set.
  def create
    gearset.update(gearset_params)
  end

  # Fire when a Equipment chenged.
  def update
    gearset.update(gearset_params)
  end

  def show
    @set = Gearset.find(params[:id])
    item = Item.joins(:description).select("items.*, items.#{I18n.locale} AS name, descriptions.#{I18n.locale} AS description").where(id: @set.slot_item.values).to_a
    @items = @set.slot_item.compact.invert.sort.to_h.values.zip(item.map {|i| i.attributes}).to_h.with_indifferent_access
  end

  def descriptions
    gear_id = JSON.parse(ajax_params)
    results = {
      descriptions: Description.where(item_id: gear_id).pluck(:item_id, I18n.locale).to_h,
      checkparam: Gearset.checkparam(gear_id)
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
