source 'https://rubygems.org'

git_source(:github) do |repo|
  "https://github.com/#{repo}.git"
end

ruby '2.6.1'

# Main gems
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'sqlite3', '~> 1.4.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Debug it!
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Load your env vars correctly
  gem 'dotenv-rails'
end

group :development do
  # Better loading
  gem 'spring'
  gem 'web-console', '>= 3.3.0'

  # Beautify your life
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry'
  gem 'pry-rails'

  # Write in style:)
  gem 'rubocop'

  # Open mail in dev
  gem 'letter_opener'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
