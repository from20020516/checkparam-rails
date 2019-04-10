include Common
class Gearset < ApplicationRecord
  include ApplicationHelper
  belongs_to :user
  belongs_to :job

  def slot_item
    self.slice(slots.pluck(:en))
  end

  # showで使う
  def checkparam
    Common.checkparam(self.slice(slots.pluck(:en)).values)
  end
end