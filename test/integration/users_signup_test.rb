require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "displays error messages on invalid submissions" do
  	get signup_path
  	assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
  	assert_template 'users/new'
  end

  test "it saves user on valid submission" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path params: {
        user: {
          name: "Bob",
          email: "valid@gmail.com",
          password: "foobar",
          password_confirmation: "foobar"
        }
      }
    end
    follow_redirect!
    assert_template "users/show"
    assert is_logged_in?
  end
end
