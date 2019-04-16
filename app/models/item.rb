class Item < ApplicationRecord
  has_one :stat, dependent: :destroy
end