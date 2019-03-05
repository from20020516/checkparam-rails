class User < ApplicationRecord
  # Include default devise modules. Others available are: https://qiita.com/gakkie/items/6ef70c0788c3cbff81ee
  devise :database_authenticatable, :omniauthable, :rememberable, :trackable # :registerable, :validatable, :recoverable, :confirmable, :lockable, :timeoutable
  has_many :gearsets, dependent: :destroy
  has_one :job, primary_key: :job_id, foreign_key: :id

  ## 以下の2つは同じ意味 # job_id columnがあればjobidを省略可能
  # belongs_to :job, primary_key: :id, foreign_key: :jobid
  # has_one :job, primary_key: :jobid, foreign_key: :id

  private

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
       job_id:   1,
       index:    1,
     )
   end

   user
  end
end