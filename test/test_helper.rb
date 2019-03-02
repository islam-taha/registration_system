ENV['RAILS_ENV'] = 'test'

require_relative '../config/environment'
require 'rails/test_help'
require 'dotenv'
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/test/'
end

Dotenv.overload!('.env.test')

module ActiveSupport
  class TestCase
    fixtures :all

    def sign_in(user)
      post new_session_path, params: {
        user: { email: user.email, password: 'asdfasdf' }
      }
    end
  end
end
