require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:valid)

    sign_in(@user)
  end

  test 'PUT #update with valid data' do
    put update_profile_url, params: {
      user: {
        name: 'abcdefg',
        password: 'password',
        password_confirmation: 'password'
      }
    }

    assert_redirected_to profile_path
    assert_equal @user.reload.name, 'abcdefg'
    assert_equal 'Profile updated successfully!', flash[:notice]
    assert_not_equal @user.reload.authenticate('password'), false
  end

  test 'PUT #update with email should not change email' do
    put update_profile_url, params: {
      user: {
        name: 'abcdefg',
        email: 'abc@example.com',
        password: 'asdfasdf',
        password_confirmation: 'asdfasdf'
      }
    }

    assert_redirected_to profile_path
    assert_equal 'Profile updated successfully!', flash[:notice]
    assert_not_equal @user.reload.name, 'abc@example.com'
  end

  test 'PUT #update without password should not update password' do
    put update_profile_url, params: {
      user: {
        name: 'abcdefg',
        email: 'abc@example.com',
      }
    }

    assert_redirected_to profile_path
    assert_equal 'Profile updated successfully!', flash[:notice]
    assert_not_equal @user.reload.name, 'abc@example.com'
    assert_not_equal @user.reload.authenticate('asdfasdf'), false
  end

  test 'PUT #update with invalid name' do
    put update_profile_url, params: {
      user: {
        name: 'a',
      }
    }

    assert_redirected_to profile_path
    assert_not_nil       flash[:alert]
    assert_not_equal     @user.reload.name, 'abc@example.com'
  end
end
