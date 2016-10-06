class SerialSearchesController < ApplicationController
  def index
    @title = 'Serial Searches'
    per_page = params[:per_page] || 50
    page = params[:page] || 1
    @serial_searches = SerialSearch.page(page).per(per_page)
  end

  def show
    @serial_search = SerialSearch.find(params[:id])
    @title = "Serial Searches for #{@serial_search.serial}"
  end
end
