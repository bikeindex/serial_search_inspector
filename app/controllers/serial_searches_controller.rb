class SerialSearchesController < ApplicationController
  helper_method :sort_column, :sort_direction
  skip_before_action :ensure_superuser, only: [:index]
  before_action :ensure_user, only: [:index]

  def index
    if current_user.superuser?
      @title = 'Serial Searches'
      per_page = params[:per_page] || 50
      page = params[:page] || 1
      @serial_searches_count = SerialSearch.count
      @ip_addresses_count = IpAddress.count
      @serial_searches = SerialSearch.order(sort_column + ' ' + sort_direction).page(page).per(per_page)
      render 'superuser'
    else
      render 'index'
    end
  end

  def show
    @serial_search = SerialSearch.find(params[:id])
    @title = "Serial Searches for #{@serial_search.serial}"
  end

  private

  def sort_column
    SerialSearch.column_names.include?(params[:sort]) ? params[:sort] : 'serial'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
