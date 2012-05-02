require 'test_helper'

class SolutionsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @tom_solution = solutions(:solution_one)
    @jack_solution = solutions(:solution_two)
    @solution_in_the_work = solutions(:solution_in_the_work)
    @solution_launched = solutions(:solution_launched)    
    @under_review = ideas(:under_review)    
    @in_the_works = ideas(:in_the_works)    
    @launched = ideas(:launched)    
    @tom = users(:tom)
  end

  test "everybody not create" do
    xhr :post,:create,:idea_id => @under_review.id
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid solution" do
    sign_in @tom
    assert_difference('Solution.count') do
      xhr :post,:create, {:idea_id => @under_review.id,:solution=>{:title => "my title",:content => "my content"}}
    end
    assert assigns(:solution).errors.empty?
    assert_response :success
  end

  test "login user not create solution to in the work idea" do
    sign_in @tom
    assert_no_difference('Solution.count') do
      xhr :post,:create, {:idea_id => @in_the_works.id,:solution=>{:title => "my title",:content => "my content"}}
    end
    assert assigns(:solution).errors.any?
    assert_response :success
  end

  test "login user not create solution to launched idea" do
    sign_in @tom
    assert_no_difference('Solution.count') do
      xhr :post,:create, {:idea_id => @launched.id,:solution=>{:title => "my title",:content => "my content"}}
    end
    assert assigns(:solution).errors.any?
    assert_response :success
  end

  test "everybody not update" do
    xhr :put,:update,:id => @tom_solution.id
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update own solution" do
    sign_in @tom
    title = "update solution title"
    @tom_solution.title = title
    xhr :put,:update, id: @tom_solution.to_param, solution: @tom_solution.attributes
    assert assigns(:solution).errors.empty?
    assert_equal title,Solution.find(@tom_solution.id).title
    assert_response :success
  end

  test "login user not update other solution" do
    sign_in @tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update, id: @jack_solution.to_param, solution: @jack_solution.attributes
    }
  end

  test "login user not update solution of in the work idea" do
    sign_in @tom
    xhr :put,:update, id: @solution_in_the_work.to_param, solution: @solution_in_the_work.attributes
    assert assigns(:solution).errors.any?
    assert_response :success
  end

  test "login user not update solution of launched idea" do
    sign_in @tom
    xhr :put,:update, id: @solution_launched.to_param, solution: @solution_launched.attributes
    assert assigns(:solution).errors.any?
    assert_response :success
  end

 test "everybody not destroy" do
    xhr :delete,:destroy,{:id => @tom_solution.id}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user destroy own solution" do
    sign_in @tom
    assert_difference('Solution.count',-1) do
      xhr :delete,:destroy,{:id => @tom_solution.id}
    end 
    assert_response :success
  end

  test "login user not destroy other solution" do
    sign_in @tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :delete,:destroy,{:id => @jack_solution.id}
    }
  end

  test "login user not destroy solution of in the work idea" do
    sign_in @tom
    assert_no_difference('Solution.count') do
      xhr :delete,:destroy,{:id => @solution_in_the_work.id}
    end 
    assert assigns(:solution).errors.any?
    assert_response :success
  end

  test "login user not destroy solution of launched idea" do
    sign_in @tom
    assert_no_difference('Solution.count') do
      xhr :delete,:destroy,{:id => @solution_launched.id}
    end 
    assert assigns(:solution).errors.any?
    assert_response :success
  end

end
