class IpAddressesController < ApplicationController
  def index
    @title = 'IP Addresses'
    per_page = params[:per_page] || 50
    page = params[:page] || 1
    @ip_addresses = IpAddress.page(page).per(per_page)
  end
end
