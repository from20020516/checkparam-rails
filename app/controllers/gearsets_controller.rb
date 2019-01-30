class GearsetsController < ApplicationController
  require 'byebug'
  include ApplicationHelper
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
    @sets_limit = 20 # header
    if current_user.present?
      @gearset = Gearset.find_or_create_by(user_id: current_user.id, jobid: current_user.jobid, setid: current_user.setid)
      # toArray for Cache
      # TODO: Items+Dscriptions JOINしちゃう??
      @gearlist = Item.where('job & ? > 0', 2**current_user.jobid).order(current_user.lang)
        .pluck(:id, :ja, :en).to_a

      #byebug

      params.require(:gearset).permit(
        :id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet) if params[:gearset].present?
    end
  end
end