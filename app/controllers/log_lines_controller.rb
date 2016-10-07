class LogLinesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    require 'papertrail_output_processor'
    if params[:api_authorization_key] == ENV['API_AUTH_KEY']
      parsed_events = JSON.parse(params[:payload]).with_indifferent_access[:events]
      PapertrailOutputProcessor.new.create_log_lines_from_events(parsed_events)
    else
      render json: { 'Message': 'Error: Invalid API Authorization Key' }, status: :unauthorized and return
    end
  end
end
