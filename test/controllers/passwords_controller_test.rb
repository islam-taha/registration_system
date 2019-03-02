require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper
  include ActiveJob::TestHelper
  include ActiveSupport::Testing::TimeHelpers

  def setup
    @user = users(:valid)
  end

  def set_reset_password_token
    @user.set_reset_password_token
    @user.pub_key
  end

  test 'POST #create with valid data' do
    perform_enqueued_jobs do
      assert_emails(1) do
        post new_password_url, params: { user: { email: @user.email } }
      end

      assert_redirected_to password_path
      assert_equal flash[:notice], 'Reset password instructions sent successfully!'
      assert_not_nil @user.reload.reset_password_token
    end
  end

  test 'POST #create with invalid email' do
    perform_enqueued_jobs do
      assert_emails(0) do
        post new_password_url, params: { user: { email: 'abc@example.com' } }
      end

      assert_redirected_to password_path
      assert_equal flash[:alert], 'No user found with this email!'
    end
  end

  test 'GET #edit with valid reset token' do
    @user.reset_password_token         = 'abcdefg'
    @user.reset_password_token_sent_at = 1.minute.ago

    get edit_password_url, params: { reset_password_token: 'abcdefg' }

    assert_equal response.status, 200
  end

  test 'GET #edit with invalid reset token' do
    @user.reset_password_token         = 'abcdefg'
    @user.reset_password_token_sent_at = 1.minute.ago

    get edit_password_url

    assert_redirected_to session_path
    assert_equal flash[:alert], 'No password token found!'
  end

  test 'PUT #update with valid data' do
    token = set_reset_password_token

    put update_password_url, params: {
      reset_password_token: token,
      user: {
        password: 'asdfasdf',
        password_confirmation: 'asdfasdf'
      }
    }

    assert_redirected_to profile_path
    assert_equal flash[:notice], 'Password resetted successfully!'
  end

  test 'PUT #update with invalid data' do
    token = set_reset_password_token

    put update_password_url, params: {
      reset_password_token: token,
      user: {
        password: '12345678'
      }
    }

    assert_redirected_to edit_password_path(reset_password_token: token)
    assert_not_nil flash[:alert]
  end

  test 'PUT #update with expired token' do
    token = set_reset_password_token

    travel(6.hours + 1.second) do
      put update_password_url, params: {
        reset_password_token: token,
        user: {
          password: '12345678',
          password_confirmation: '12345678'
        }
      }
    end

    assert_redirected_to edit_password_path(reset_password_token: token)
    assert_not_nil flash[:alert]
  end
end
