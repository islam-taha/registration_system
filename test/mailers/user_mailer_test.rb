require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'welcome_email' do
    user  = users(:valid)
    email = UserMailer.with(user: user).welcome_email

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['from@example.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Welcome to my web app!', email.subject
  end

  test 'reset_password' do
    user = users(:valid)
    user.set_reset_password_token

    email = UserMailer.with(user: user, token: user.pub_key).reset_password

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['from@example.com'], email.from
    assert_equal [user.email], email.to
    assert_equal 'Request to reset your password', email.subject
    assert_not_nil email.to_s.index('reset_password_token')
  end
end
