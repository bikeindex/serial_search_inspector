require 'rails_helper'

RSpec.describe BikeIndexRequestorJob, type: :job do
  describe 'perform' do
    ActiveJob::Base.queue_adapter = :inline

  end
end
