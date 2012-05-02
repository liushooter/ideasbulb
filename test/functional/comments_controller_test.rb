require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @a_comment = comments(:a_comment)
    @jack_comment = comments(:jack_comment)
    @under_review = ideas(:under_review)    
    @tom = users(:tom)
  end

  test "everybody not create" do
    xhr :post,:create,:idea_id => @under_review.id
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid comment" do
    sign_in @tom
    assert_difference('Comment.count') do
      xhr :post,:create,{:idea_id => @under_review.id,comment: @a_comment.attributes}
    end
    assert_response :success
  end

  test "login user create invalid comment" do
    sign_in @tom
    @a_comment.content = ""
    assert_no_difference('Topic.count') do
      xhr :post,:create,{:idea_id => @under_review.id,comment: @a_comment.attributes}
    end
    assert_response :success
  end

  test "everybody not destroy" do
    xhr :delete,:destroy,{:id => @a_comment.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user destroy" do
    sign_in @tom
    assert_difference('Comment.count',-1) do
      xhr :delete,:destroy,{:id => @a_comment.id}
    end 
    assert_response :success
  end
 
  test "login user not destroy other comment" do
    sign_in @tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :delete,:destroy,{:id => @jack_comment.id}
    }
  end
 
  test "everybody not update" do
    xhr :put,:update,{:id => @a_comment.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update valid comment" do
    sign_in @tom
    assert_no_difference('Comment.count') do
      xhr :put,:update,{:id => @a_comment.id,:comment => {:content => "update a name"}}
    end
    assert assigns(:comment).errors.empty?
    assert_response :success
  end

  test "login user update invalid comment" do
    sign_in @tom
    assert_no_difference('Comment.count') do
      xhr :put,:update,{:id => @a_comment.id,:comment => {:content => " "}}
    end
    assert assigns(:comment).errors.any?
    assert_response :success
  end

  test "login user not update other comment" do
    sign_in @tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update, id: @jack_comment.to_param, idea: @jack_comment.attributes
    }
  end
end
