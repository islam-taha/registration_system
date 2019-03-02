# Registration system
User registration system without devise like gems help

## Requirements
ruby version `2.6.1`

## Setup

1. `cp .env.sample .env` *note: you can change the env vars to suit your needs*
2. `bundle install`
3. `bundle exec rake db:create`
4. `bundle exec rake db:migrate`

**secret_token inside .env/.env.test files is so important to exist**

## Running the server
- `bundle exec foreman s -e .env`

## Running test cases
1. `RAILS_ENV=test be rake db:create db:migrate`
2. `be rails test`

**Now you can open the browser with localhost:3000 (you can change the port in the .env file).**
