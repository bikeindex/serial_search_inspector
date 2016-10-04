class LogLinesController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]

  def create
    require 'papertrail_output_processor'
    pp JSON.parse(params[:payload])
    pp '****************'
    parsed_payload = JSON.parse(params[:payload])
    pp parsed_payload[:events]
    # if params[:payload].present?
    PapertrailOutputProcessor.new.create_log_lines_from_events(params[:payload][:events])
    # else
    #   render json: 'Error: Invalid Payload', status: :bad_request and return
    # end
  end
end
