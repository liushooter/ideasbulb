require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @jack = users(:jack)
    @tom = users(:tom)
  end

  test "normal user not get index" do
    sign_in @tom
    get :index
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin get index" do
    sign_in @jack
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "normal user not authority" do
    sign_in @tom
    xhr :put,:authority,{id: @tom.to_param,admin:"true"}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "admin authority" do
    sign_in @jack
    xhr :put,:authority,{id: @tom.to_param,admin:"true"}
    assert_response :success
    assert assigns(:user).errors[:base].empty?
  end

  test "everybody show user" do
    get :show, id: @tom.to_param
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "login user edit himself" do
    sign_in @tom
    get :edit,{id: @tom.to_param}
    assert_response :success
  end

  test "login user not edit other" do
    sign_in @tom
    get :edit,{id: @jack.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "everybody not edit user" do
    get :edit, id: @tom.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end
  
  test "login user update himself" do
    sign_in @tom
    put :update,{id: @tom.to_param,:user => {:description => "a test description",:website => "http://www.danthought.com" }}
    assert_redirected_to edit_user_path(@tom)
    assert_equal I18n.t('app.notice.user.edit'),flash[:notice]
  end

  test "login user update himself invalid" do
    sign_in @tom
    put :update,{id: @tom.to_param,:user => {:description => "a test description",:website => "www.danthought.com" }}
    assert_template "edit"
    assert assigns(:user).invalid?
  end

  test "everybody not update user" do
    put :update, id: @tom.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

end
