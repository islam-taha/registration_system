require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = users(:valid)
    assert user.valid?
  end

  test 'invalid without name' do
    user = users(:invalid_name)
    assert_not_nil user.errors[:name]
  end

  test 'invalid without email' do
    user = users(:invalid_email)
    assert_not_nil user.errors[:email]
  end

  test 'invalid without password' do
    user          = users(:valid)
    user.password = nil

    assert_not_nil user.errors[:password]
  end

  test 'invalid with same email' do
    user1 = users(:valid)
    user2 = users(:valid)

    user2.update_attributes(email: user1.email)

    assert_not_nil user2.errors[:email]
  end

  test 'invalid with name.length < 5' do
    user = users(:valid)
    user.update_attributes(name: 'a')

    assert_not_nil user.errors[:name]
  end
end
