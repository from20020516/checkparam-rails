class Description < ApplicationRecord
  belongs_to :item, foreign_key: :id
end