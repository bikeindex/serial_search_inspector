class GraphsController < ApplicationController
  def index
    @title = 'Graphs'
    @serial_searches = SerialSearch.all
    @ip_addresses = IpAddress.all
    @log_lines = LogLine.all
  end

  def source_type
    render json: LogLine.group(:search_source).count
  end

  def unique_created_day
    render json:
      [
        { name: 'Serial Searches', data: SerialSearch.group_by_hour_of_day(:created_at).count},
        { name: 'IP Addresses', data: IpAddress.group_by_hour_of_day(:created_at).count},
        { name: 'Log Lines', data: LogLine.group_by_hour_of_day(:created_at).count }
      ].chart_json
  end

  def unique_created_week
    render json:
      [
        { name: 'Serial Searches', data: SerialSearch.group_by_day(:created_at).count},
        { name: 'IP Addresses', data: IpAddress.group_by_day(:created_at).count},
        { name: 'Log Lines', data: LogLine.group_by_day(:created_at).count }
      ].chart_json
  end


def unique_created_month
    render json:
      [
        { name: 'Serial Searches', data: SerialSearch.group_by_day_of_month(:created_at).count},
        { name: 'IP Addresses', data: IpAddress.group_by_day_of_month(:created_at).count},
        { name: 'Log Lines', data: LogLine.group_by_day_of_month(:created_at).count }
      ].chart_json
  end


def unique_created_year
    render json:
      [
        { name: 'Serial Searches', data: SerialSearch.group_by_month_of_year(:created_at).count},
        { name: 'IP Addresses', data: IpAddress.group_by_month_of_year(:created_at).count},
        { name: 'Log Lines', data: LogLine.group_by_month_of_year(:created_at).count }
      ].chart_json
  end

  def unique_created
    pp params
    grouping = params['grouping']
    render json:
      [
        { name: 'Serial Searches', data: SerialSearch.grouped_by(grouping)(:created_at).count},
        { name: 'IP Addresses', data: IpAddress.grouped_by(grouping)(:created_at).count},
        { name: 'Log Lines', data: LogLine.group_by(grouping)(:created_at).count }
      ].chart_json
  end

  private

  def grouped_by(parameter)
    'group_by_hour_of_day'
  end
end
