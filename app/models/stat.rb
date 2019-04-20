class Stat < ApplicationRecord
  belongs_to :item
  scope :names, -> { column_names - %w[id item_id created_at updated_at Ｄ] }
  # TODO: decide
  scope :current_stat, ->(*args) { where(item_id: args).group_by(&:item_id) }
  scope :current, ->(*args) { where(item_id: args) }
end
