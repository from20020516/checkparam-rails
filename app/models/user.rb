class User < ApplicationRecord
  devise :database_authenticatable, :omniauthable, :rememberable

  has_many :gearsets
  belongs_to :job

  serialize :auth
  before_save :prepare_save

  def prepare_save
    if auth.class == String
      begin
        self.auth = JSON.parse(auth).deep_transform_keys(&:to_sym)
      rescue
        # TODO: fix eval.
        self.auth = eval(auth).deep_transform_keys(&:to_sym)
      rescue => e
        pp e
      end
    end
    self
  end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
      unless user
        user = User.create(
          uid:      auth.uid,
          password: Devise.friendly_token[0, 20],
          provider: auth.provider,
          lang:     auth&.extra&.raw_info&.[](:lang) == 'ja' ? 'ja' : 'en',
        )
      end
      user.update(
        email: auth.info.email,
        auth: auth.to_json
      )
    user
  end
end