module AuthenticationHelper
  extend ActiveSupport::Concern

  def ensure_authorized_user
    if current_user.present?
      verify_authorization
    else
      session[:sandr] ||= request.url unless controller_name.match('session')
      redirect_to user_bike_index_omniauth_authorize_path and return
    end
  end

  def user_root_url
    root_url
    # return root_url unless current_user.present?
    # if current_user.admin?
    #   admin_dashboard_controller
    # else
    #   root_url
    # end
  end

  # def admin_root_url
  #   admin_dashboard_controller
  # end

  def verify_authorization(action=action_name, obj=controller_name.to_s)
    return true if (current_user || User.new).is_authorized?(action, obj)
    flash[:error] = "You don't have permission to do that!"
    redirect_to user_root_url and return
  end

  def ssl_configured?
    Rails.env.production?
  end

protected
  def strict_transport_security
    if request.ssl?
      response.headers['Strict-Transport-Security'] = "max-age=31536000;"
    end
  end
end
