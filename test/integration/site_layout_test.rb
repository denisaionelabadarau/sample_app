require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "layout links" do
    get root_path
    # verify that the right page template is rendered
    assert_template 'static_pages/home'
    # check for the correct links
    assert_select "a[href=?]", root_path, count: 2 #one for the logo, one for the navigation menu elem
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path

    get signup_path
    assert_select "title", full_title("Sign Up")
  end

  test "layout links for login user" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 #one for the logo, one for the navigation menu elem
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", edit_user_path(@user)
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
  end
end
