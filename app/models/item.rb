class Item < ApplicationRecord
  has_one :stat, dependent: :destroy

  serialize :description
  before_save :prepare_save

  def prepare_save
    if description.class == String
      begin
        # TODO: fix eval.
        self.description = eval(description)&.transform_keys(&:to_sym)

      rescue => e
        pp e
      end
    end
    self
  end
end