require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {name: "", email: "foo@invalid", password: "foo", password_confirmation: "bar"}}
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
    assert_select "li", "Name can't be blank"
    assert_select "li", "Email is invalid"
    assert_select "li", "Password confirmation doesn't match Password"
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'test', email: 'test33@gmail.com', password: 'parola', password_confirmation: 'parola' }}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
