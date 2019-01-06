class GearsetsController < ApplicationController
  before_action :authenticate_user!, only: :update

  def index
  end

  def about
  end

  def update
    @gearset = Gearset.find(params[:id])
    @gearset.update_attributes(params_int(params[:gearset]))
  end

  private

  def gearset_params
     params.require(:gearset).permit(:id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet)
  end

  def params_int(model_params)
    model_params.each do |key,value|
      model_params[key] = value.to_i
    end
  end
end
