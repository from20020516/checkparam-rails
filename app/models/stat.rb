# frozen_string_literal: true

class Stat < ApplicationRecord
  belongs_to :item
  before_update :prepare_update

  scope :names, -> { column_names - %w[id item_id created_at updated_at Ｄ] }
  scope :current, ->(*ids) { where(item_id: ids) }

  # TODO: Non-attribute arguments will be disallowed in Rails 6.0. This method should not be called with user-provided values, such as request parameters or model attributes. Known-safe values can be passed by wrapping them in Arel.sql().
  scope :checkparam, lambda { |*ids|
    # names.map(&:to_sym).zip(current(ids).pluck(names.to_sym).transpose.map(&:sum)).to_h
    names.map(&:to_sym).zip(current(ids).pluck(:HP, :MP, :STR, :DEX, :VIT, :AGI, :INT, :MND, :CHR, :隔, :防, :命中, :飛命, :魔命, :攻, :飛攻, :魔攻, :回避, :魔回避, :魔防, :ヘイスト, :敵対心, :被ダメージ, :被物理ダメージ, :被魔法ダメージ, :ストアTP, :ファストキャスト, :精霊魔法の詠唱時間, :回復魔法の詠唱時間, :ケアル詠唱時間, :魔法ダメージ, :魔法剣ダメージ, :ファランクス, :マジックバーストダメージ, :マジックバーストダメージII, :二刀流, :ダブルアタック, :トリプルアタック, :クワッドアタック, :ダブルショット, :トリプルショット, :クワッドショット, :スナップショット, :ラピッドショット, :ウェポンスキルのダメージ, :ケアル回復量, :ケアル回復量II, :被ケアル回復量, :クリティカルヒット, :クリティカルヒットダメージ, :ペット_命中, :ペット_魔命, :ペット_攻, :ペット_魔攻, :ペット_ダブルアタック, :ペット_リジェネ, :ペット_被ダメージ, :ペット_被物理ダメージ, :ペット_被魔法ダメージ, :契約の履行使用間隔, :契約の履行使用間隔II, :ペット_契約の履行ダメージ, :召喚獣維持費, :詠唱中断率).transpose.map(&:sum)).to_h
  }

  private

  def prepare_update
    # if changed?
    #   puts item[:ja], item[:description][:raw], changes_to_save
    #   byebug
    # end
  end
end
