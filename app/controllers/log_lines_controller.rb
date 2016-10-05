class LogLinesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    require 'papertrail_output_processor'
    puts params[:payload]
    parsed_events = JSON.parse(params[:payload]).with_indifferent_access[:events]
    # if params[:payload].present?
    PapertrailOutputProcessor.new.create_log_lines_from_events(parsed_events)
    # else
    #   render json: 'Error: Invalid Payload', status: :bad_request and return
    # end
  end
end
