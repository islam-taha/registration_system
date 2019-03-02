require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  include ActiveJob::TestHelper

  test 'POST #create with valid data' do
    perform_enqueued_jobs do
      assert_difference('User.count') do
        post new_registration_url, params: {
          user: { email: 'abc@example.com',
                  password: 'asdfasdf',
                  password_confirmation: 'asdfasdf' }
        }
      end

      assert_emails 1
      assert_redirected_to profile_path
      assert_equal 'Account created successfully!', flash[:notice]
    end
  end

  test 'POST #create with invalid email' do
    user = users(:valid)
    post new_registration_url, params: {
      user: { email: user.email,
              password: 'asdfasdf',
              password_confirmation: 'asdfasdf' }
    }

    assert_redirected_to registration_path
    assert_not_nil flash[:alert]
  end

  test 'POST #create with invalid password' do
    post new_registration_url, params: {
      user: { email: 'abc@example.com',
              password: 'asdf',
              password_confirmation: 'asdf' }
    }

    assert_redirected_to registration_path
    assert_not_nil flash[:alert]
  end

  test 'POST #create with invalid password_confirmation' do
    post new_registration_url, params: {
      user: { email: 'abc@example.com',
              password: 'asdfasdf',
              password_confirmation: 'asdflkjl8' }
    }

    assert_redirected_to registration_path
    assert_not_nil flash[:alert]
  end
end
