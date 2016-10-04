class LogLinesController < ApplicationController
  def create
    # if params[:payload].present?
    PapertrailOutputProcessor.new.create_log_lines_from_events(params[:payload][:events])
    # else
    #   render json: 'Error: Invalid Payload', status: :bad_request and return
    # end
  end
end
