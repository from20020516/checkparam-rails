class DescriptionsController < ApplicationController
  def index
    # TODO: 共通化
    gearset_id = JSON.parse(gearset_params) # ここだけ違う
      stats = Stat.where(id: gearset_id).to_a
      stat_names = Stat.column_names - %w[id created_at updated_at HP MP 防 Ｄ 隔 STR DEX AGI VIT INT MND CHR]
      checkparam = stat_names.map { |stat_name| [stat_name, stats.pluck(stat_name).compact.sum] }.to_h
    results = Item.where(id: gearset_id).pluck(:id, :description).to_h.merge(lang: session[:lang], checkparam: checkparam)
    puts results
    # byebug
    render json: results
  end

  def about
  end

  private

  def gearset_params
    return params.require(:id)
  end
end