require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user_tom_comment_under_review = comments(:user_tom_comment_under_review)
    @user_zhang_comment_under_review = comments(:user_zhang_comment_under_review)
    @user_tom_under_review = ideas(:user_tom_under_review)    
    @user_tom = users(:user_tom)
  end

  test "everybody not create" do
    xhr :post,:create,:idea_id => @user_tom_under_review.id
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid comment" do
    sign_in @user_tom
    assert_difference('Comment.count') do
      xhr :post,:create,{:idea_id => @user_tom_under_review.id,comment: @user_tom_comment_under_review.attributes}
    end
    assert_response :success
  end

  test "login user create invalid comment" do
    sign_in @user_tom
    @user_tom_comment_under_review.content = ""
    assert_no_difference('Topic.count') do
      xhr :post,:create,{:idea_id => @user_tom_under_review.id,comment: @user_tom_comment_under_review.attributes}
    end
    assert_response :success
  end

  test "everybody not destroy" do
    xhr :delete,:destroy,{:id => @user_tom_comment_under_review.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user destroy" do
    sign_in @user_tom
    assert_difference('Comment.count',-1) do
      xhr :delete,:destroy,{:id => @user_tom_comment_under_review.id}
    end 
    assert_response :success
  end
 
  test "login user not destroy other comment" do
    sign_in @user_tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :delete,:destroy,{:id => @user_zhang_comment_under_review.id}
    }
  end
 
  test "everybody not update" do
    xhr :put,:update,{:id => @user_tom_comment_under_review.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update valid comment" do
    sign_in @user_tom
    assert_no_difference('Comment.count') do
      xhr :put,:update,{:id => @user_tom_comment_under_review.id,:comment => {:content => "update a name"}}
    end
    assert assigns(:comment).errors.empty?
    assert_response :success
  end

  test "login user update invalid comment" do
    sign_in @user_tom
    assert_no_difference('Comment.count') do
      xhr :put,:update,{:id => @user_tom_comment_under_review.id,:comment => {:content => " "}}
    end
    assert assigns(:comment).errors.any?
    assert_response :success
  end

  test "login user not update other comment" do
    sign_in @user_tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update,{:id => @user_zhang_comment_under_review.id,:comment => {:content => "update a name"}}
    }
  end
end
