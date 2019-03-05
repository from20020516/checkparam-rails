class GearsetsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_user!, only: [:show, :update]
  before_action :gearset_params
  before_action :gear_list

  def index
  end

  # Fire when a Equipment chenged.
  def update
    @set.update(gearset_params)
  end

  def show
    @set = Gearset.find(params[:id])
  end

  def about
  end

  private

  def gear_list
    if current_user.present?
      @set = Gearset.find_or_create_by(user_id: current_user.id, job_id: current_user.job_id, index: current_user.index)
      @items ||= Item.where('job & ? > 0', 2**current_user.job_id).order(current_user.lang)
    end
  end

  def gearset_params
    if current_user.present?
      return params.require(:gearset).permit(:id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet) if params[:gearset].present?
    end
  end
end
