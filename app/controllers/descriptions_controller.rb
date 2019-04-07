class DescriptionsController < ApplicationController
  include ApplicationHelper
  def index
    # TODO: もう少し繰り返し減らない? Gearset.idにアクセスして、まとめて返す?
    # return JSON with /?id=[ITEM_ID]
    render json: [params[:id], Item.find(params[:id]).description[lang]] # Array
  end

  def about
  end
end