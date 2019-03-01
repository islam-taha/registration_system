require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'POST #create with valid user data' do
    user = users(:valid)

    post new_session_url, params: {
      user: { email: user.email, password: 'asdfasdf' }
    }

    assert_redirected_to profile_path
    assert_equal flash[:notice], 'Logged in successfully!'
  end

  test 'POST #create with valid user email but invalid password' do
    user = users(:valid)

    post new_session_url, params: {
      user: { email: user.email, password: 'a923947283' }
    }

    assert_redirected_to session_path
    assert_equal flash[:alert], 'Incorrect email or password, please try again later'
  end

  test 'POST #create with invalid email' do
    post new_session_url, params: {
      user: { email: 'abc@example.com', password: 'a923947283' }
    }

    assert_redirected_to session_path
    assert_equal flash[:alert], 'Incorrect email or password, please try again later'
  end
end
