class DescriptionsController < ApplicationController
  include ApplicationHelper
  def index
    # TODO: fix too many access.
    # return JSON with /?id=[ITEM_ID]
    render json: [params[:id], Item.find(params[:id]).description[lang]] # Array
  end

  def about
  end
end