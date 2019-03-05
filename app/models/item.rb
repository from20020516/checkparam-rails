class Item < ApplicationRecord
  has_one :description, dependent: :destroy, foreign_key: :id
  # has_many :gears, primary_key: :id, foreign_key: [:main,:sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet]
  ## has_many: 対象を所有,戻り値複数, has_one: 対象を所有,戻り値1, belongs_to: 被所有,戻り値1?
end