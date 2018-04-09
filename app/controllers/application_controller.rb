class ApplicationController < ActionController::Base
  before_action :ensure_superuser
  before_action :enable_mini_profiler
  protect_from_forgery with: :exception

  def ensure_user
    return true if current_user.present?

    session[:sandr] ||= request.url unless controller_name.match('session')
    redirect_to user_bike_index_omniauth_authorize_path and return
  end

  def ensure_superuser
    return unless ensure_user
    return true if current_user.superuser?

    redirect_to root_url and return
  end

  def enable_mini_profiler
    if current_user && current_user.superuser?
      Rack::MiniProfiler.authorize_request unless Rails.env.test?
    end
  end

  def ssl_configured?
    Rails.env.production?
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    session[:aso].present? ? session.delete(:aso) : 'https://bikeindex.org'
  end

  def after_sign_in_path_for(resource_or_scope)
    session[:sandr].present? ? session.delete(:sandr) : root_url
  end
end
