class Item < ApplicationRecord
  has_one :stat, dependent: :destroy
  has_one :description, dependent: :destroy
  belongs_to :wiki
end