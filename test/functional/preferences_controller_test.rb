require 'test_helper'

class PreferencesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @jack = users(:jack)
    @tom = users(:tom)
  end

  test "normal user not get dashboard" do
    sign_in @tom
    get :dashboard
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin get dashboard" do
    sign_in @jack
    get :dashboard
    assert_response :success
  end

  test "admin xhr get dashboard" do
    sign_in @jack
    xhr :get,:dashboard
    assert_response :success
  end

  test "normal user not get index" do
    sign_in @tom
    xhr :get,:index
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin get index" do
    sign_in @jack
    xhr :get,:index
    assert_response :success
  end

  test "normal user not update basic" do
    sign_in @tom
    xhr :put,:update_basic
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin update basic" do
    sign_in @jack
    xhr :put,:update_basic,{:preference_site_name => "a new site name"}
    assert_response :success
  end

end
