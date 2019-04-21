class Stat < ApplicationRecord
  belongs_to :item
  before_update :prepare_update

  scope :names, -> { column_names - %w[id item_id created_at updated_at Ｄ] }
  scope :current, ->(*ids) { where(item_id: ids) }

  # TODO: Non-attribute arguments will be disallowed in Rails 6.0. This method should not be called with user-provided values, such as request parameters or model attributes. Known-safe values can be passed by wrapping them in Arel.sql().
  scope :checkparam, -> (*ids) {
    names.map(&:to_sym).zip(current(ids).pluck(names).transpose.map(&:sum)).to_h
  }

  private

  def prepare_update
    # if changed?
    #   puts item[:ja], item[:description][:raw], changes_to_save
    #   byebug
    # end
  end
end
