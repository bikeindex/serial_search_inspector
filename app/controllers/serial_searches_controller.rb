class SerialSearchesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @title = 'Serial Searches'
    per_page = params[:per_page] || 50
    page = params[:page] || 1
    @serial_searches_count = SerialSearch.count
    @ip_addresses_count = IpAddress.count
    if params[:sort] == 'times_searched'
      @serial_searches = SerialSearch.select('*').order('log_lines_count').page(page).per(per_page)
    else
      @serial_searches = SerialSearch.order(sort_column + ' ' + sort_direction).page(page).per(per_page)
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
