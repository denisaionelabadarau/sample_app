require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest

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
end
