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
end
