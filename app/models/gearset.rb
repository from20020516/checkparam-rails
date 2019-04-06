class Gearset < ApplicationRecord
  before_validation :set_gearset
  belongs_to :user
  belongs_to :job

  private

  ## TODO: 必要??
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