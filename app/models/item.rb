class Item < ApplicationRecord
  has_one :stat, dependent: :destroy

  serialize :description
  before_save :prepare_save

  scope :current, ->(*args) { where(id: args) }
  scope :current_job, ->(job_id, lang = :ja) { where('job & ? > 0', 2**job_id).order(lang) }

  def prepare_save
    if description.class == String
      begin
        # TODO: fix eval && unuse self
        self.description = eval(description)&.transform_keys(&:to_sym)

      rescue => e
        pp e
      end
    end
    self
  end
end