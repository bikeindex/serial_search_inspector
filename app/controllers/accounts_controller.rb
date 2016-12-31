require './lib/bike_index/requester' # why doesn't this get linked up automatically?

class AccountsController < ApplicationController
  helper_method :sort_column, :sort_direction
  skip_before_action :ensure_superuser, only: [:refresh_bike_index_credentials]
  before_action :ensure_user, only: [:refresh_bike_index_credentials]

  def index
    @users = User.all
    @user_count = User.count
  end

  def show
    serials = []
    @user_serial_searches = []

    @user = User.find(params[:id])
    user_bikes = BikeIndex::Requester.new(@user).get_bikes

    user_bikes['bikes'].each { |bike| serials << bike['serial'] }

    serials.each do |serial|
      @user_serial_searches << SerialSearch.find_by(serial: serial)
    end
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
