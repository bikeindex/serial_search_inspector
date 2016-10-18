class GraphsController < ApplicationController
  def index
    @title = 'Graphs'
    @serial_searches = SerialSearch.all
    @ip_addresses = IpAddress.all
    @log_lines = LogLine.all
  end

  def source_type
    @log_lines = LogLine.without_inspector_requests.where('created_at >= ?', 7.day.ago)
    render json: (source_type_with_sources + source_type_with_types).chart_json
  end

  def uniquely_created_entries
    if params['grouping'] == 'day'
      render json:
        [
          { name: 'Valid Serial Searches', data: SerialSearch.where('created_at >= ?', 1.day.ago).group_by_hour(:created_at).count },
          { name: 'Unique IP Addresses', data: IpAddress.where('created_at >= ?', 1.day.ago).group_by_hour(:created_at).count },
          { name: 'Total Serial Searches', data: LogLine.without_inspector_requests.where('created_at >= ?', 1.day.ago).group_by_hour(:created_at).count }
        ].chart_json
    elsif params['grouping'] == 'week'
      render json:
        [
          { name: 'Valid Serial Searches', data: SerialSearch.where('created_at >= ?', 7.day.ago).group_by_day(:created_at).count },
          { name: 'Unique IP Addresses', data: IpAddress.where('created_at >= ?', 7.day.ago).group_by_day(:created_at).count },
          { name: 'Total Serial Searches', data: LogLine.without_inspector_requests.where('created_at >= ?', 7.day.ago).group_by_day(:created_at).count }
        ].chart_json
    elsif params['grouping'] == 'month'
      render json:
        [
          { name: 'Valid Serial Searches', data: SerialSearch.where('created_at >= ?', 30.day.ago).group_by_day(:created_at).count },
          { name: 'Unique IP Addresses', data: IpAddress.where('created_at >= ?', 30.day.ago).group_by_day(:created_at).count },
          { name: 'Total Serial Searches', data: LogLine.without_inspector_requests.where('created_at >= ?', 30.day.ago)].group_by_day(:created_at).count }
        ].chart_json
    else
      render json:
        [
          { name: 'Valid Serial Searches', data: SerialSearch.group_by_week(:created_at).count },
          { name: 'Unique IP Addresses', data: IpAddress.group_by_week(:created_at).count },
          { name: 'Total Serial Searches', data: LogLine.without_inspector_requests.group_by_week(:created_at).count }
        ].chart_json
    end
  end

  private

  def source_type_with_types
    LogLine.search_types.map do |search_type|
      {
        name: search_type.titleize,
        data: @log_lines.with_search_type.where(search_type: search_type).group_by_day(:created_at).count
      }
    end
  end

  def source_type_with_sources
    LogLine.search_sources.map do |search_source|
      {
        name: search_source.titleize,
        data: @log_lines.with_search_source.where(search_source: search_source).group_by_day(:created_at).count
      }
    end
  end
end
