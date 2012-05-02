require 'test_helper'

class VotesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @solution_two = solutions(:solution_two)
    @solution_in_the_work = solutions(:solution_in_the_work)
    @solution_one_vote_like_one = votes(:solution_one_vote_like_one)
    @solution_one_vote_unlike_one = votes(:solution_one_vote_unlike_one)
    @solution_in_the_work_vote_like = votes(:solution_in_the_work_vote_like)
    @jack = users(:jack)
    @tom = users(:tom)
  end

  test "everybody not create" do
    xhr :post,:create,{:solution_id => @solution_two.id,:like => true}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid vote" do
    sign_in @tom
    assert_difference('Vote.count') do
      xhr :post,:create, {:solution_id => @solution_two.id,:like => true}
    end
    assert assigns(:vote).errors.empty?
    assert_response :success
  end

  test "login user not create vote to solution of in the work idea" do
    sign_in @tom
    assert_no_difference('Vote.count') do
      xhr :post,:create, {:solution_id => @solution_in_the_work.id,:like => true}
    end
    assert assigns(:vote).errors.any?
    assert_response :success
  end

  test "everybody not update" do
    xhr :put,:update,{:id => @solution_one_vote_like_one.id,:like => true}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update own vote" do
    sign_in @tom
    xhr :put,:update, {:id => @solution_one_vote_like_one.id,:like => false}
    assert assigns(:vote).errors.empty?
    assert_equal false,Vote.find(@solution_one_vote_like_one.id).like
    assert_response :success
  end

  test "login user not update other vote" do
    sign_in @tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update, {:id => @solution_one_vote_unlike_one.id,:like => true}
    }
  end

  test "login user not update vote to solution of in the work idea" do
    sign_in @tom
    xhr :put,:update, {:id => @solution_in_the_work_vote_like.id,:like => false}
    assert assigns(:vote).errors.any?
    assert_response :success
  end

 test "everybody not destroy" do
    xhr :delete,:destroy,{:id => @solution_one_vote_like_one.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user destroy own vote" do
    sign_in @tom
    assert_difference('Vote.count',-1) do
      xhr :delete,:destroy,{:id => @solution_one_vote_like_one.id}
    end 
    assert_response :success
  end

  test "login user not destroy other vote" do
    sign_in @tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :delete,:destroy,{:id => @solution_one_vote_unlike_one.id}
    }
  end

  test "login user not destroy vote to solution of in the work idea" do
    sign_in @tom
    assert_no_difference('Vote.count') do
      xhr :delete,:destroy,{:id => @solution_in_the_work_vote_like.id}
    end 
    assert assigns(:vote).errors.any?
    assert_response :success
  end

end
