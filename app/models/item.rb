class Item < ApplicationRecord
  has_one :description, dependent: :destroy, primary_key: :id, foreign_key: :id
end