class GearsetsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: [:create, :update]
  before_action :gearset_params

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
  end

  private

  def gearset_params
    if current_user.present?
      return params.require(:gearset).permit(:id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet) if params[:gearset].present?
    end
  end
end
