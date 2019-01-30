class Gearset < ApplicationRecord
  belongs_to :user
  ## overwrite default attr_accessor??
  # attr_accessor :id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet
  before_validation :set_gearset

  private

  def set_gearset
    h = self.attributes
    h.each do |key,value|
      if (h[key].class == NilClass || h[key].class == Integer) && key != "id"
        h[key] = value.to_i
      end
    end
    self.attributes = h
  end
end