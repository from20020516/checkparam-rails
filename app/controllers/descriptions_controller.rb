class DescriptionsController < ApplicationController
  def index
    # return JSON with /?id=[ITEM_ID]
    if current_user.present?
      @description = Description.find(params[:id]).slice(:id, current_user.lang)
      render json: @description
    end
  end
end