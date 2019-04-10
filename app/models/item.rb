class Item < ApplicationRecord
  has_one :stat, dependent: :destroy
  #accepts_nested_attributes_for :stat, update_only: true

  has_one :description, dependent: :destroy
  #accepts_nested_attributes_for :description, update_only: true

  belongs_to :wiki
end