require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user_tom_solution_reviewed_success = solutions(:user_tom_solution_reviewed_success)
    @user_tom_solution_under_review = solutions(:user_tom_solution_under_review)
    @user_tom_solution_launched = solutions(:user_tom_solution_launched)
    @user_tom_vote = votes(:user_tom_vote)
    @user_zhang_vote = votes(:user_zhang_vote)
    @user_tom_vote_launched = votes(:user_tom_vote_launched)
    @user_tom = users(:user_tom)
    @user_mick = users(:user_mick)
  end

  test "everybody not create" do
    xhr :post,:create,{:solution_id => @user_tom_solution_reviewed_success.id,:like => true}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid vote" do
    sign_in @user_mick
    assert_difference('Vote.count') do
      xhr :post,:create, {:solution_id => @user_tom_solution_reviewed_success.id,:like => true}
    end
    assert assigns(:vote).errors.empty?
    assert_response :success
  end

  test "login user not create vote to solution of under review idea" do
    sign_in @user_mick
    assert_no_difference('Vote.count') do
      xhr :post,:create, {:solution_id => @user_tom_solution_under_review.id,:like => true}
    end
    assert assigns(:vote).errors.any?
    assert_response :success
  end

  test "login user not create vote to solution of launched idea" do
    sign_in @user_mick
    assert_no_difference('Vote.count') do
      xhr :post,:create, {:solution_id => @user_tom_solution_launched.id,:like => true}
    end
    assert assigns(:vote).errors.any?
    assert_response :success
  end

  test "everybody not update" do
    xhr :put,:update,{:id => @user_tom_vote.id,:like => true}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update own vote" do
    sign_in @user_tom
    xhr :put,:update, {:id => @user_tom_vote.id,:like => false}
    assert assigns(:vote).errors.empty?
    assert_equal false,Vote.find(@user_tom_vote.id).like
    assert_response :success
  end

  test "login user not update other vote" do
    sign_in @user_tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update, {:id => @user_zhang_vote.id,:like => true}
    }
  end

  test "login user not update vote to solution of launched idea" do
    sign_in @user_tom
    xhr :put,:update, {:id => @user_tom_vote_launched.id,:like => false}
    assert assigns(:vote).errors.any?
    assert_response :success
  end

 test "everybody not destroy" do
    xhr :delete,:destroy,{:id => @user_tom_vote.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user destroy own vote" do
    sign_in @user_tom
    assert_difference('Vote.count',-1) do
      xhr :delete,:destroy,{:id => @user_tom_vote.id}
    end 
    assert_response :success
  end

  test "login user not destroy other vote" do
    sign_in @user_tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :delete,:destroy,{:id => @user_zhang_vote.id}
    }
  end

  test "login user not destroy vote to solution of launched idea" do
    sign_in @user_tom
    assert_no_difference('Vote.count') do
      xhr :delete,:destroy,{:id => @user_tom_vote_launched.id}
    end 
    assert assigns(:vote).errors.any?
    assert_response :success
  end

end
