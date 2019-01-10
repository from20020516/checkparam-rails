class GearsetsController < ApplicationController
  before_action :authenticate_user!, only: [:show, :update]
  before_action :current_gearset, only: [:show, :update]

  #require 'byebug'

  def index
  end

  def about
  end

  def update # 装備セット変更
    @gearset.update_attributes(gearset_params)
  end

  def show # 装備セット公開
  end

  private

  def current_gearset
    @gearset = Gearset.find(params[:id])
  end

  def gearset_params
    params.require(:gearset).permit(:id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet)
  end

  # def set_gearset
  #   self.attributes[:gearset].each do |key,value|
  #     self.attributes[key] = value ? value.to_i : 0
  #   end
  # end
end