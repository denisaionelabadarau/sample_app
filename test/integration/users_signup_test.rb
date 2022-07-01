require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

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

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'test', email: 'test33@gmail.com', password: 'parola', password_confirmation: 'parola' }}
    end
    
    assert_equal 1, ActionMailer::Base.deliveries.size

    user = assigns(:user)
    assert_not user.activated?

    # try to log in before activation
    log_in_as(user)
    assert_not is_logged_in?

    # invalid activation link
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?

    # valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'invalid@gmail.com')
    assert_not is_logged_in?

    # valid activation token
    get edit_account_activation_path(user.activation_token, email:  user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
