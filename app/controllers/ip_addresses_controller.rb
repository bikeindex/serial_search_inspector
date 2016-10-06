class IpAddressesController < ApplicationController
  def index
    @title = 'IP Addresses'
    per_page = params[:per_page] || 50
    page = params[:page] || 1
    @ip_addresses = IpAddress.page(page).per(per_page)
  end

  def show
    @ip_address = IpAddress.find(params[:id])
    @title = "Searches from #{@ip_address.address}"
  end
end
