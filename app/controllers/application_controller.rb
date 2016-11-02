class ApplicationController < ActionController::Base
  include AuthenticationHelper
  # ensure_security_headers
  # before_action :ensure_authorized_user
  protect_from_forgery with: :exception
end
