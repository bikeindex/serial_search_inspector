class User < ApplicationRecord
  has_many :user_bikes
  has_many :bikes, through: :user_bikes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.from_omniauth(uid, auth)
    where(binx_id: uid.to_i).first_or_create do |user|
      user.binx_info = auth.to_h
      user.email = user.binx_info['info']['email']
      user.username = "binx_id#{uid}"
      user.password = Devise.friendly_token[0, 20]
      user.binx_credentials = user.binx_info.delete 'credentials'
    end
  end

  def update_binx_credentials(auth)
    new_cred = auth.to_h['credentials']
    update_attribute :binx_credentials, new_cred unless binx_credentials == new_cred
  end

  def superuser?
    superuser
  end
end
