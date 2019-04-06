class Item < ApplicationRecord
  has_one :stat, dependent: :destroy, foreign_key: :id
end