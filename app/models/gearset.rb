class Gearset < ApplicationRecord
require 'byebug'
  ## overwrite default attr_accessor??
  # attr_accessor :id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet
  before_validation :set_gearset
  belongs_to :user
  belongs_to :job

  private

  def set_gearset
    h = self.attributes
    h.each do |key,value|
      if h[key].class == Integer
        h[key] = value.to_i
      end
    end
    self.attributes = h
  end
end