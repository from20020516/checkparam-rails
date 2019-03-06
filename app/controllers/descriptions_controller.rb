class DescriptionsController < ApplicationController
  include ApplicationHelper
  def index
    # return JSON with /?id=[ITEM_ID]
    @description = Description.find(params[:id]).slice(:id, lang)
    render json: @description
  end
end