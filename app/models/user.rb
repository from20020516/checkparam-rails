# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :rememberable, :omniauthable, omniauth_providers: %i[twitter]

  has_many :gearsets
  belongs_to :job

  serialize :auth
  before_save :prepare_save

  def prepare_save
    if auth.class == String
      begin
        self.auth = JSON.parse(auth).deep_transform_keys(&:to_sym)
      rescue StandardError
        # TODO: fix eval.
        self.auth = eval(auth).deep_transform_keys(&:to_sym)
      rescue StandardError => e
        pp e
      end
    end
    self
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.uid = auth.uid
      user.password = Devise.friendly_token[0, 20]
      user.provider = auth.provider
      user.lang = auth&.extra&.raw_info&.[](:lang) == 'ja' ? 'ja' : 'en'
      user.email = auth.info.email
      user.auth = auth.to_json
    end
  end
end
