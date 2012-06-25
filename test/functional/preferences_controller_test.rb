require 'test_helper'

class PreferencesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @admin_jack = users(:admin_jack)
    @user_tom = users(:user_tom)
  end

  test "normal user not get dashboard" do
    sign_in @user_tom
    get :dashboard
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin get dashboard" do
    sign_in @admin_jack
    get :dashboard
    assert_response :success
  end

  test "admin xhr get dashboard" do
    sign_in @admin_jack
    xhr :get,:dashboard
    assert_response :success
  end

  test "normal user not get index" do
    sign_in @user_tom
    xhr :get,:index
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin get index" do
    sign_in @admin_jack
    xhr :get,:index
    assert_response :success
  end

  test "normal user not update basic" do
    sign_in @user_tom
    xhr :put,:update_basic
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin update basic" do
    sign_in @admin_jack
    xhr :put,:update_basic,{:preference_site_name => "a new site name"}
    assert_response :success
  end

end
