ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
