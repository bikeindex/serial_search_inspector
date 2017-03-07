task associate_log_lines: :environment do
  # Sidekiq processes new logs too quickly and causes database failures
  LogLineAssociaterJob.perform_later
end

task reset_log_lines_counters: :environment do
  SerialSearch.find_each { |serial| SerialSearch.reset_counters(serial.id, :log_lines) }
  IpAddress.find_each { |ip| IpAddress.reset_counters(ip.id, :log_lines) }
end

task search_bike_index: :environment do
  SerialSearch.all.each do |serial_search|
    BikeIndexRequestorJob.perform_later(serial_search)
  end
end

task fetch_all_user_bikes: :environment do
  User.all.each do |user|
    FetchBikeIndexBikesJob.perform_later(user)
  end
end

task fetch_bikes_by_binx_id: :environment do
  puts 'Batching all bicycles..'

  Bike.find_in_batches(batch_size: 100) do |batch|
    wait_time = 1

    batch.each do |bike|
      FetchBikeByBikeIndexIdJob.set(wait: wait_time.minutes).perform_later(bike)
      wait_time += 2
    end
  end
end
