class User < ApplicationRecord
  # Include default devise modules. Others available are: https://qiita.com/gakkie/items/6ef70c0788c3cbff81ee
  devise :database_authenticatable, :omniauthable, :rememberable, :trackable
  #, :registerable, :validatable, :recoverable, :confirmable, :lockable, :timeoutable

  has_many :gearsets, dependent: :destroy
  has_one :job, primary_key: :job_id, foreign_key: :id

  private

  def self.find_for_oauth(auth)
   user = User.where(uid: auth.uid, provider: auth.provider).first

   unless user
     user = User.create(
       uid:      auth.uid,
       password: Devise.friendly_token[0, 20],
       provider: auth.provider,
       lang:     auth.extra.raw_info.lang == 'ja' ? 'ja' : 'en',
       job_id:   1,
       index:    1,
     )
   end

   user.update(
     image:     auth.extra.raw_info.profile_image_url_https,
     email:     auth.info.email,
     nickname:  auth.info.nickname,
     name:      auth.info.name,
    )

   user
  end
end