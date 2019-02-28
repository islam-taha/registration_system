# Registration system
User registration system without devise-like gems help

## Requirements
ruby version `2.6.1`

## Setup

1. `cp .env.sample .env` *note: you can change the env vars to suit your needs*
2. `bundle install`
3. `bundle exec rake db:create`
4. `bundle exec rake db:migrate`

## Running the server
- `bundle exec rails s`

**Now you can open the browser with localhost:3000 (you can change the port in the .env file).**
