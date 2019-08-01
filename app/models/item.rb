# frozen_string_literal: true

class Item < ApplicationRecord
  # TODO: augments
  has_one :stat, dependent: :destroy

  serialize :description
  before_validation :prepare_save

  scope :current, ->(*args) { where(id: args) }
  scope :current_job, ->(job_id, lang = :ja) { where('job & ? > 0', 2**job_id).order(lang) }

  def parse
    str = description[:raw].sub(/(デュナミス〔Ｄ〕:|潜在能力:)/, '')
    def status(str)
      hash = Hash.new(0)
      str.split(/\s/).flat_map { |stat| stat.sub(/ユニティランク\:(.+)([+-])\d+～(\d+%?)/, '\1\2\3').scan(/(\D+?)([+-]?\d+)%?$/) }.each { |key, value| hash[key] += value.to_i }
      hash
    end
    sep = str.partition(/ペット:|召喚獣:|飛竜:|オートマトン:|羅盤:/)
    res = status(sep[0])&.merge(status(sep[2]).transform_keys { |key| 'ペット_' + key }).map do |key, value|
      [key.to_sym, value.to_i] if Stat.names.include?(key)
    end .compact.to_h # TODO: use 'sep[1]+key' instead 'ペット_'
    begin
      stat.update(res)
    rescue StandardError => e
      Stat.create(id: id).update(res)
    end
  end

  def convert_job(bin)
    return { ja: 'All Jobs', en: 'All Jobs' } if bin.to_i == 8388606

    res = Job.pluck(:jas, :ens).zip(format('%#024b', bin.to_i).split('').map(&:to_i).reverse).map { |k, v| k * v }.reject(&:blank?).transpose
    { ja: res[0].join, en: res[1].join('/') }
  end

  def init(data)
    item_data = data[1][0].merge(description: data[1][1]).with_indifferent_access

    update(slot: item_data[:slots], job: item_data[:jobs], ja: item_data[:ja], en: item_data[:en],
           wiki_id: self[:wiki_id] || Wiki.find_by(ja: item_data[:ja])&.id || Wiki.find_by(ja: item_data[:ja].gsub(/(\+[1-3]$|改$|^[真極])/, ''))&.id)
    begin
      # byebug
      update(description: {
               ja: "<a href='http://wiki.ffo.jp/html/#{self[:wiki_id]}.html' target='_blank'>#{item_data[:ja]}</a><br>#{item_data[:description][:ja]&.gsub(/\n/, '<br>')}<br>#{convert_job(item_data[:jobs])[:ja]}",
               en: "<a href='http://wiki.ffo.jp/html/#{self[:wiki_id]}.html' target='_blank'>#{item_data[:en]}</a><br>#{item_data[:description][:en]&.gsub(/\n/, '<br>')}<br>#{convert_job(item_data[:jobs])[:en]}",
               raw: item_data[:description][:ja]
             })
    rescue StandardError => e
      puts e, item_data
      update(description: {
               ja: "<a href='http://wiki.ffo.jp/html/#{self[:wiki_id]}.html' target='_blank'>#{item_data[:ja]}</a><br><br>#{convert_job(item_data[:jobs])[:ja]}",
               en: "<a href='http://wiki.ffo.jp/html/#{self[:wiki_id]}.html' target='_blank'>#{item_data[:en]}</a><br><br>#{convert_job(item_data[:jobs])[:en]}",
               raw: ''
             })
    end
    parse
  end

  private

  def prepare_save
    self.description = eval(description)&.transform_keys(&:to_sym) if description.class == String
  end
end
