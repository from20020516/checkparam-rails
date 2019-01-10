class Gearset < ApplicationRecord
  belongs_to :user
  ## overwrite default attr_accessor??
  # attr_accessor :id, :main, :sub, :range, :ammo, :head, :neck, :ear1, :ear2, :body, :hands, :ring1, :ring2, :back, :waist, :legs, :feet
  before_validation :set_gearset

  #require 'byebug'

  private
  
  def set_gearset
    self.attributes[:gearset].each do |key,value|
      self.attributes[key] = value ? value.to_i : 0
    end
  end
end
