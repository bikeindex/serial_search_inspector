class IpAddressesController < ApplicationController
  helper_method :sort_column, :sort_direction

  before_action :find_ip_address, except: [:index]

  def index
    @title = 'IP Addresses'
    per_page = params[:per_page] || 50
    page = params[:page] || 1
    @serial_searches_count = SerialSearch.count
    @ip_addresses_count = IpAddress.count
    @ip_addresses = IpAddress.order(sort_column + ' ' + sort_direction).page(page).per(per_page)
  end

  def show
    @title = "Searches from #{@ip_address.address}"
  end

  def edit
    @title = "Edit #{@ip_address.address}"
  end

  def update
    if @ip_address.update_attributes(ip_params)
      @ip_address.log_lines.each do |log_line|
        log_line.update_attribute(:inspector_request, log_line.inspector_request?)
      end
      redirect_to ip_address_path(@ip_address)
    else
      render :edit
    end
  end

  private

  def ip_params
    params.require(:ip_address).permit(:name, :notes, :started_being_inspector_at, :stopped_being_inspector_at)
  end

  def find_ip_address
    @ip_address = IpAddress.find(params[:id])
  end

  def sort_column
    IpAddress.column_names.include?(params[:sort]) ? params[:sort] : 'address'
  end

  def sort_direction
    %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
