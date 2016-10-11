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

  def uniquely_created_entries
    if params['grouping'] == 'day'
      render json:
        [
          { name: 'Serial Searches', data: SerialSearch.where('created_at >= ?', 1.day.ago).group_by_hour(:created_at).count },
          { name: 'IP Addresses', data: IpAddress.where('created_at >= ?', 1.day.ago).group_by_hour(:created_at).count },
          { name: 'Log Lines', data: LogLine.where('created_at >= ?', 1.day.ago).group_by_hour(:created_at).count }
        ].chart_json
    elsif params['grouping'] == 'week'
      render json:
        [
          { name: 'Serial Searches', data: SerialSearch.where('created_at >= ?', 7.day.ago).group_by_day(:created_at).count },
          { name: 'IP Addresses', data: IpAddress.where('created_at >= ?', 7.day.ago).group_by_day(:created_at).count },
          { name: 'Log Lines', data: LogLine.where('created_at >= ?', 7.day.ago).group_by_day(:created_at).count }
        ].chart_json
    elsif params['grouping'] == 'month'
      render json:
        [
          { name: 'Serial Searches', data: SerialSearch.where('created_at >= ?', 30.day.ago).group_by_day(:created_at).count },
          { name: 'IP Addresses', data: IpAddress.where('created_at >= ?', 30.day.ago).group_by_day(:created_at).count },
          { name: 'Log Lines', data: LogLine.where('created_at >= ?', 30.day.ago).group_by_day(:created_at).count }
        ].chart_json
    else
      render json:
        [
          { name: 'Serial Searches', data: SerialSearch.group_by_week(:created_at).count },
          { name: 'IP Addresses', data: IpAddress.group_by_week(:created_at).count },
          { name: 'Log Lines', data: LogLine.group_by_week(:created_at).count }
        ].chart_json
    end
  end
end
