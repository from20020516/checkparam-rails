class DescriptionsController < ApplicationController
  def index
    # TODO: /checkparam output
    render json: Item.where(id: JSON.parse(gearset_params)).pluck(:id, :description).to_h.merge(lang: session[:lang])
  end

  def about
  end

  private

  def gearset_params
    return params.require(:id)
  end
end