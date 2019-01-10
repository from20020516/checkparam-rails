class GearsetsController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  # before_action :authenticate_user!, only: [:show :update]
  before_action :require_gearset, only: [:show, :update]

  def index
  end

  def about
  end

  # 装備セット変更
  def update
    @gearset.update_attributes(params_int(params[:gearset]))
  end

  # 装備セット公開
  def show
  end

  private

  def require_gearset
    @gearset = Gearset.find(params[:id])
    #require 'byebug'; byebug
  end

  def gearset_params
     params.require(:gearset).permit(:id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet)
  end

  def params_int(model_params)
    model_params.each do |key,value|
      model_params[key] = value.to_i
    end
  end
end