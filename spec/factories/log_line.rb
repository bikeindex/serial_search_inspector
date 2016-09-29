FactoryGirl.define do
  factory :log_line do
    entry { JSON.parse(File.read('./spec/fixtures/log_line.json')) }
    before(:create) do |log|
      log.update_attributes(log.attributes_from_entry)
    end
    request_at { Time.now } # need to change the time of each log_line for creation
  end
end
