# Bike Index Serial Search Inspector
[![Build Status](https://travis-ci.org/bikeindex/serial_search_inspector.svg?branch=tables)](https://travis-ci.org/bikeindex/serial_search_inspector)
[![Code Climate](https://codeclimate.com/github/bikeindex/serial_search_inspector/badges/gpa.svg)](https://codeclimate.com/github/bikeindex/serial_search_inspector)
[![Test Coverage](https://codeclimate.com/github/bikeindex/serial_search_inspector/badges/coverage.svg)](https://codeclimate.com/github/bikeindex/serial_search_inspector/coverage)

[Serial Search Inspector](https://inspector.bikeindex.org/) is a Rails application integrated with [Papertrail](https://papertrailapp.com/) to monitor the bicycle serial number searches on [Bike Index](https://bikeindex.org).

## Dependencies

| What            | Install             | Notes |
| --------------- | -------------------------- | ----- |
| Rails 5.0.0.1   | [Ruby on Rails](http://rubyonrails.org/)
| Ruby 2.2.5      | [rvm](https://github.com/wayneeseguin/rvm), [rbenv](https://github.com/sstephenson/rbenv) with [ruby-build](https://github.com/sstephenson/ruby-build) or [from source.](http://www.ruby-lang.org/en/) | |
| PostgreSQL 9.5.3| [Postgres.app](http://postgresapp.com/), `brew install postgresql` on OSX, [on Linux](http://www.postgresql.org/download/linux/ubuntu/) | |
| Sidekiq         | [Sidekiq](https://github.com/mperham/sidekiq), which requires [Redis](https://redis.io/) | |


## Setup

- `bundle install`
- `bundle exec rake db:create`
- `bundle exec rake db:migrate`
- `bundle exec rake db:test:prepare`
- `./start` use the included [bash script](https://github.com/bikeindex/serial_search_inspector/blob/master/start) to start the development server
- Go to [localhost:5000](http://localhost:5000)

While this is enough for local development, to completely setup the Serial Search Inspector a running instance of [Bike Index](https://bikeindex.org) and log output from [Papertrail](https://papertrailapp.com/) is required.

Create a Papertrail webhook and POST logs to `your_inspector_address.com/log_lines?api_authorization_key=xxxx`

All serial number searches on your BikeIndex instance will now be forwarded and processed through the Inspector

## Testing

Serial Search Inspector uses [Guard](https://github.com/guard/guard) to test. Run `bundle exec guard`
