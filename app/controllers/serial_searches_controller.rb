class SerialSearchesController < ApplicationController
  def index
    @serial_searches = SerialSearch.page(params[:page]).per(10)
  end

  def show
    @serial_search = SerialSearch.find(params[:id])
  end
end
