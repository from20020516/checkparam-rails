class User < ApplicationRecord
  devise :database_authenticatable, :omniauthable, :rememberable
  #, :timeoutable, :trackable, :registerable, :validatable, :recoverable, :confirmable, :lockable

  has_many :gearsets, dependent: :destroy
  has_one :job, primary_key: :job_id, foreign_key: :id

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first
      unless user
        user = User.create(
          uid:      auth.uid,
          password: Devise.friendly_token[0, 20],
          provider: auth.provider,
          lang:     auth.extra.raw_info.lang == 'ja' ? 'ja' : 'en',
        )
      end
      user.update(
        email:      auth.info.email,
        auth:       auth,
      )
    user
  end
end