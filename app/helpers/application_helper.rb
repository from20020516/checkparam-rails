module ApplicationHelper
  def slots
    Slot.all
  end

  def items
    Item
  end
end