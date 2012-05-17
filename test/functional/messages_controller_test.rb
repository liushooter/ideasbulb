require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @jack = users(:jack)
    @tom = users(:tom)
    @message =  messages(:one)
  end

  test "everybody not get show" do
    get :show,{id: @message.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user get show own mesage" do
    sign_in @tom
    get :show,{id: @message.to_param}
    assert_redirected_to @message.link
    assert Message.find(@message.id).readed
  end

  test "login user get show other message" do
    sign_in @jack
    assert_raise(ActiveRecord::RecordNotFound){
      get :show,{id: @message.to_param}
    }
  end

end
