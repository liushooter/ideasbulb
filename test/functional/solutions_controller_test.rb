require 'test_helper'

class SolutionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user_tom_solution_under_review = solutions(:user_tom_solution_under_review)
    @user_tom_solution_reviewed_success = solutions(:user_tom_solution_reviewed_success)
    @user_tom_solution_launched = solutions(:user_tom_solution_launched)
    @user_zhang_solution_under_review = solutions(:user_zhang_solution_under_review)
    @user_tom_under_review = ideas(:user_tom_under_review)    
    @user_tom_launched = ideas(:user_tom_launched)    
    @user_tom = users(:user_tom)
  end

  test "everybody not create" do
    xhr :post,:create,:idea_id => @user_tom_under_review.id
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid solution" do
    sign_in @user_tom
    assert_difference('Solution.count') do
      xhr :post,:create, {:idea_id => @user_tom_under_review.id,:solution=>{:title => "my title",:content => "my content"}}
    end
    assert assigns(:solution).errors.empty?
    assert_response :success
  end

  test "login user create invalid solution" do
    sign_in @user_tom
    assert_no_difference('Solution.count') do
      xhr :post,:create, {:idea_id => @user_tom_under_review.id,:solution=>{:title => "",:content => "my content"}}
    end
    assert assigns(:solution).errors.any?
    assert_response :success
  end

  test "login user not create solution to launched idea" do
    sign_in @user_tom
    assert_no_difference('Solution.count') do
      xhr :post,:create, {:idea_id => @user_tom_launched.id,:solution=>{:title => "my title",:content => "my content"}}
    end
    assert assigns(:solution).errors.any?
    assert_response :success
  end

  test "everybody not update" do
    xhr :put,:update,:id => @user_tom_solution_reviewed_success.id
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update own solution" do
    sign_in @user_tom
    title = "update solution title"
    @user_tom_solution_reviewed_success.title = title
    xhr :put,:update, id: @user_tom_solution_reviewed_success.to_param, solution: @user_tom_solution_reviewed_success.attributes
    assert assigns(:solution).errors.empty?
    assert_equal title,Solution.find(@user_tom_solution_reviewed_success.id).title
    assert_response :success
  end

  test "login user update own invalid solution" do
    sign_in @user_tom
    title = ""
    @user_tom_solution_reviewed_success.title = title
    xhr :put,:update, id: @user_tom_solution_reviewed_success.to_param, solution: @user_tom_solution_reviewed_success.attributes
    assert assigns(:solution).errors.any?
    assert_response :success
  end

  test "login user not update other solution" do
    sign_in @user_tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update, id: @user_zhang_solution_under_review.to_param, solution: @user_zhang_solution_under_review.attributes
    }
  end

  test "login user not update solution of launched idea" do
    sign_in @user_tom
    xhr :put,:update, id: @user_tom_solution_launched.to_param, solution: @user_tom_solution_launched.attributes
    assert assigns(:solution).errors.any?
    assert_response :success
  end

 test "everybody not destroy" do
    xhr :delete,:destroy,{:id => @user_tom_solution_reviewed_success.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user destroy own solution" do
    sign_in @user_tom
    assert_difference('Solution.count',-1) do
      xhr :delete,:destroy,{:id => @user_tom_solution_reviewed_success.id}
    end 
    assert_response :success
  end

  test "login user not destroy other solution" do
    sign_in @user_tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :delete,:destroy,{:id => @user_zhang_solution_under_review.id}
    }
  end

  test "login user not destroy solution of launched idea" do
    sign_in @user_tom
    assert_no_difference('Solution.count') do
      xhr :delete,:destroy,{:id => @user_tom_solution_launched.id}
    end 
    assert assigns(:solution).errors.any?
    assert_response :success
  end

end
