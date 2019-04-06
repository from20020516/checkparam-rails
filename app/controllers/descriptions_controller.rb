class DescriptionsController < ApplicationController
  include ApplicationHelper
  def index
    # return JSON with /?id=[ITEM_ID]
    @description = [params[:id], Item.find(params[:id]).description[lang]] # Array
    render json: @description
  end

  def about
  end
end