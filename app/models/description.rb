class Description < ApplicationRecord
  belongs_to :item, primary_key: :id, foreign_key: :id
end