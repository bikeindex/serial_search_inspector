# [Bike Index Serial Search Inspector](https://inspector.bikeindex.org/)
[![Build Status](https://travis-ci.org/bikeindex/serial_search_inspector.svg?branch=tables)](https://travis-ci.org/bikeindex/serial_search_inspector)
[![Code Climate](https://codeclimate.com/github/bikeindex/serial_search_inspector/badges/gpa.svg)](https://codeclimate.com/github/bikeindex/serial_search_inspector)
[![Test Coverage](https://codeclimate.com/github/bikeindex/serial_search_inspector/badges/coverage.svg)](https://codeclimate.com/github/bikeindex/serial_search_inspector/coverage)

## Dependencies

| What            | Install             | Notes |
| --------------- | -------------------------- | ----- |
| Rails 5.0.0.1   | [Ruby on Rails](http://rubyonrails.org/)
| Ruby 2.2.5      | [rvm](https://github.com/wayneeseguin/rvm), [rbenv](https://github.com/sstephenson/rbenv) with [ruby-build](https://github.com/sstephenson/ruby-build) or [from source.](http://www.ruby-lang.org/en/) | |
| PostgreSQL 9.5.3| [Postgres.app](http://postgresapp.com/), `brew install postgresql` on OSX, [on Linux](http://www.postgresql.org/download/linux/ubuntu/) | |

## Setup
```
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:test:prepare
```

## Testing
Serial Search Inspector uses Guard to test. Run `bundle exec guard`
