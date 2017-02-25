class AccountsController < ApplicationController
  helper_method :sort_column, :sort_direction
  skip_before_action :ensure_superuser, only: [:refresh_bike_index_credentials]
  before_action :ensure_user, only: [:refresh_bike_index_credentials]

  def index
    @users = User.all
    @user_count = User.count
  end

  def show
    @user = User.find(params[:id])
  end

  def refresh_bike_index_credentials
    session[:aso] = root_url
    redirect_to destroy_user_session_path(method: :delete)
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
