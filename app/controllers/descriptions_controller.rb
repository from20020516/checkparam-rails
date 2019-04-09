class DescriptionsController < ApplicationController
  # include ApplicationHelper
  def index
    item_id = JSON.parse(gearset_params)
    items = Item.where(id: item_id).pluck(:id, :description).to_h
    #byebug
    render json: item_id.map{ |id| [id, items[id.to_i]&.dig(session[:lang])] }.to_h
  end

  def about
  end

  private

  def gearset_params
    return params.require(:id)
  end
end