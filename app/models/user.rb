class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # https://qiita.com/gakkie/items/6ef70c0788c3cbff81ee
  devise :database_authenticatable, :omniauthable, :rememberable, :trackable
  # :registerable, :validatable, :recoverable, :confirmable, :lockable, :timeoutable,
  has_many :gearsets, dependent: :destroy

  def self.find_for_oauth(auth)
   user = User.where(uid: auth.uid, provider: auth.provider).first

   unless user
     user = User.create(
       uid:      auth.uid,
       provider: auth.provider,
       email:    auth.info.email, # require APIs permission.
       lang:     auth.extra.raw_info.lang == "ja" ? "ja" : "en",
       password: Devise.friendly_token[0, 20],
       image:    auth.info.image.gsub("http","https"),
       nickname: auth.info.nickname,
       name:     auth.info.name,
       jobid:    1,
       setid:    1,
     )
   end

   user
  end
end