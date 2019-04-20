class Stat < ApplicationRecord
  belongs_to :item

  # TODO: replace colon ':' to underscore '_'
  scope :names, -> { column_names - %w[id item_id created_at updated_at Ｄ ペット:命中 ペット:魔命 ペット:攻 ペット:魔攻 ペット:ダブルアタック ペット:リジェネ ペット:被ダメージ ペット:被物理ダメージ ペット:被魔法ダメージ ペット:契約の履行ダメージ] }
  scope :current, ->(*ids) { where(item_id: ids) }

  # TODO: Non-attribute arguments will be disallowed in Rails 6.0. This method should not be called with user-provided values, such as request parameters or model attributes. Known-safe values can be passed by wrapping them in Arel.sql().
  scope :checkparam, -> (*ids) {
    names.map(&:to_sym).zip(current(ids).pluck(names).transpose.map(&:compact).map(&:compact).map(&:sum)).to_h
  }
end
