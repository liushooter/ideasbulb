require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @admin_jack = users(:admin_jack)
    @user_tom = users(:user_tom)
    @user_tom_message =  messages(:user_tom_message)
  end

  test "everybody not get mesage" do
    get :show,{id: @user_tom_message.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user get own mesage" do
    sign_in @user_tom
    get :show,{id: @user_tom_message.to_param}
    assert_redirected_to @user_tom_message.link
    assert Message.find(@user_tom_message.id).readed
  end

  test "login user not get other message" do
    sign_in @admin_jack
    assert_raise(ActiveRecord::RecordNotFound){
      get :show,{id: @user_tom_message.to_param}
    }
  end

end
