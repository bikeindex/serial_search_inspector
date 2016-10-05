class SearchedBikeIndexLastJob < ApplicationJob
  queue_as :default

  def perform(serial_search)

  end
end


    # pp serial_search.log_lines
    # array = []
    # serial_search.log_lines.each do |log_line|
    #   array << log_line
    # end
    # array.sort_by do |log_line|
    #   log_line.request_at
    # end
    # pp array
    # serial_search.update_attribute(:searched_bike_index_at, array[0].find_request_at)