class User < ApplicationRecord
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
    has_role?(:superuser)
  end

  def appraiser?
    has_role?(:appraiser)
  end

  def programmer?
    has_role?(:programmer)
  end

  def is_authorized?(action='write', obj)
    # return true if superuser?
    # return true if appraiser?
    if obj.kind_of?(String)
      return true if ['messages', 'sessions',
        'registrations', 'account', 'bikes', 'graphs', 'ip_addresses', 'log_lines', 'serial_searches'].include?(obj.downcase.strip)
    else
      return true if obj && defined?(obj.user) && obj.user.present? && obj.user == self
      return true if self == obj
    end
    false
  end
end
