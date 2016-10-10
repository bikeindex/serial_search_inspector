class IpAddressesController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @title = 'IP Addresses'
    per_page = params[:per_page] || 50
    page = params[:page] || 1
    @ip_addresses = IpAddress.page(page).per(per_page).order(sort_column + ' ' + sort_direction)
    @serial_searches_count = SerialSearch.count
    @ip_addresses_count = IpAddress.count
  end

  def show
    @ip_address = IpAddress.find(params[:id])
    @title = "Searches from #{@ip_address.address}"
  end

  private

  def sort_column
    IpAddress.column_names.include?(params[:sort]) ? params[:sort] : 'address'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
