require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @under_review = ideas(:under_review)
    @reviewed_fail = ideas(:reviewed_fail)
    @reviewed_success = ideas(:reviewed_success)
    @in_the_works = ideas(:in_the_works)
    @launched = ideas(:launched)
    @jack_idea = ideas(:jack_idea)
    @jack = users(:jack)
    @tom = users(:tom)
  end

  test "everybody get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ideas)
  end
  
  test "everybody get search" do
    get :search,:q => "test"
    assert_response :success
  end
=begin
  test "everybody not get promotion" do
    get :promotion
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user get promotion" do
    get :promotion,nil,{:login_user => LoginUser.new(@tom)}
    assert_response :success
  end
=end
  test "everybody show idea" do
    get :show, id: @under_review.to_param
    assert_response :success
    assert_not_nil assigns(:idea)
    assert assigns(:idea_page)
  end

  test "everybody not create" do
    xhr :post,:create
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid idea" do
    sign_in @tom
    @under_review.tag_names = ""
    assert_difference('Idea.count') do
      xhr :post,:create,{idea: @under_review.attributes}
    end
    assert_response :success
  end

  test "login user create valid idea with tag" do
    sign_in @tom
    @under_review.tag_names = "test good"
    assert_difference('Idea.count') do
      xhr :post,:create,{idea: @under_review.attributes}
    end
    assert_response :success
  end

  test "login user create invalid idea" do
    sign_in @tom
    @under_review.title = nil
    assert_no_difference('Idea.count') do
      xhr :post,:create,{idea: @under_review.attributes}
    end
    assert assigns(:idea).errors.any?
  end

  test "everybody not update idea" do
    xhr :put,:update,{ id: @under_review.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update own valid idea" do
    sign_in @tom
    title = "updated title" 
    @under_review.title = title
    assert_no_difference('Idea.count') do
      xhr :put,:update,{id: @under_review.to_param,idea:@under_review.attributes},
    end
    assert assigns(:idea).errors.empty?
    assert_equal title,Idea.find(@under_review.id).title 
    assert_response :success
  end

  test "login user update own invalid idea" do
    sign_in @tom
    @under_review.title = ""
    assert_no_difference('Idea.count') do
      xhr :put,:update,{id: @under_review.to_param,idea:@under_review.attributes},
    end
    assert assigns(:idea).errors.any?
    assert_response :success
  end

  test "login user not update other idea" do
    sign_in @tom
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update, id: @jack_idea.to_param, idea: @jack_idea.attributes
    }
  end

  test "login user not update in the work idea" do
    sign_in @tom
    title = "in the work title" 
    @in_the_works.title = title
    assert_no_difference('Idea.count') do
      xhr :put,:update,{id: @in_the_works.to_param,idea:@in_the_works.attributes},
    end
    assert assigns(:idea).errors.any?
    assert_not_equal title,Idea.find(@in_the_works.id).title 
    assert_response :success
  end

  test "login user not update launched idea" do
    sign_in @tom
    title = "launched title" 
    @launched.title = title
    assert_no_difference('Idea.count') do
      xhr :put,:update,{id: @launched.to_param,idea:@launched.attributes},
    end
    assert assigns(:idea).errors.any?
    assert_not_equal title,Idea.find(@launched.id).title 
    assert_response :success
  end

  test "everybody not handle idea" do
    post :handle,{ id: @under_review.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user not handle idea" do
    sign_in @tom
    post :handle,{ id: @under_review.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end
  
  test "admin reviewed success valid idea" do
    sign_in @jack
    post :handle,{id: @under_review.to_param,:status => IDEA_STATUS_REVIEWED_SUCCESS}
    assert_redirected_to idea_path(assigns(:idea))
    assert_nil flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_SUCCESS,Idea.find(@under_review.id).status
  end
  
  test "admin reviewed success invalid idea" do
    sign_in @jack
    post :handle,{id: @under_review.to_param,:status => IDEA_STATUS_IN_THE_WORKS}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{IDEA_STATUS_REVIEWED_SUCCESS}")),flash[:alert]
    assert_equal IDEA_STATUS_UNDER_REVIEW,Idea.find(@under_review.id).status
  end

  test "admin reviewed fail valid idea" do
    sign_in @jack
    post :handle,{id: @under_review.to_param,:status => IDEA_STATUS_REVIEWED_FAIL,:fail => IDEA_FAIL_REPEATED }
    assert_redirected_to idea_path(assigns(:idea))
    assert_nil flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_FAIL,Idea.find(@under_review.id).status
  end
  
  test "admin reviewed fail invalid idea" do
    sign_in @jack
    post :handle,{id: @under_review.to_param,:status => IDEA_STATUS_IN_THE_WORKS,:fail => IDEA_FAIL_REPEATED }
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{IDEA_STATUS_REVIEWED_FAIL}")),flash[:alert]
    assert_equal IDEA_STATUS_UNDER_REVIEW,Idea.find(@under_review.id).status
  end

  test "admin recovery valid idea" do
    sign_in @jack
    post :handle,{id: @reviewed_fail.to_param,:status => IDEA_STATUS_UNDER_REVIEW}
    assert_redirected_to idea_path(assigns(:idea))
    assert_nil flash[:alert]
    assert_equal IDEA_STATUS_UNDER_REVIEW,Idea.find(@reviewed_fail.id).status
  end
  
  test "admin recovery invalid idea" do
    sign_in @jack
    post :handle,{id: @reviewed_fail.to_param,:status => IDEA_STATUS_IN_THE_WORKS}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{IDEA_STATUS_UNDER_REVIEW}")),flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_FAIL,Idea.find(@reviewed_fail.id).status
  end

  test "admin work on valid idea" do
    sign_in @jack
    post :handle,{id: @reviewed_success.to_param,:status => IDEA_STATUS_IN_THE_WORKS,:solutionIds => [solutions(:solution_one).id,solutions(:solution_two).id]}
    assert_redirected_to idea_path(assigns(:idea))
    assert_nil flash[:alert]
    assert_equal IDEA_STATUS_IN_THE_WORKS,Idea.find(@reviewed_success.id).status
  end
  
  test "admin work on invalid idea" do
    sign_in @jack
    post :handle,{id: @reviewed_success.to_param,:status => IDEA_STATUS_LAUNCHED,:solutionIds => [solutions(:solution_one).id,solutions(:solution_two).id]}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{IDEA_STATUS_IN_THE_WORKS}")),flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_SUCCESS,Idea.find(@reviewed_success.id).status
  end

  test "admin work on idea with no solution" do
    sign_in @jack
    post :handle,{id: @reviewed_success.to_param,:status => IDEA_STATUS_IN_THE_WORKS}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.pick_solution'),flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_SUCCESS,Idea.find(@reviewed_success.id).status
  end

  test "admin launch valid idea" do
    sign_in @jack
    post :handle,{id: @in_the_works.to_param,:status => IDEA_STATUS_LAUNCHED}
    assert_redirected_to idea_path(assigns(:idea))
    assert_nil flash[:alert]
    assert_equal IDEA_STATUS_LAUNCHED,Idea.find(@in_the_works.id).status
  end
  
  test "admin launch invalid idea" do
    sign_in @jack
    post :handle,{id: @in_the_works.to_param,:status => IDEA_STATUS_UNDER_REVIEW}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{IDEA_STATUS_LAUNCHED}")),flash[:alert]
    assert_equal IDEA_STATUS_IN_THE_WORKS,Idea.find(@in_the_works.id).status
  end

  test "admin not handle launched idea" do
    sign_in @jack
    post :handle,{id: @launched.to_param}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.launched'),flash[:alert]
    assert_equal IDEA_STATUS_LAUNCHED,Idea.find(@launched.id).status
  end

  test "everybody get tab" do
    xhr :get,:tab
    assert_response :success
    assert_not_nil assigns(:ideas)
  end

  test "everybody get tag" do
    get :tag,{ :tag_id => tags(:design).id}
    assert_response :success
    assert_not_nil assigns(:tag)
    assert_not_nil assigns(:ideas)
  end

  test "everybody not favoriate idea" do
    xhr :post,:favoriate,id: @under_review.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "everybody not unfavoriate idea" do
    xhr :post,:unfavoriate,id: @under_review.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user favoriate idea" do
    sign_in @tom
    xhr :post, :favoriate,{id: @under_review.to_param}
    assert_response :success
  end

  test "login user unfavoriate idea" do
    sign_in @tom
    xhr :post, :unfavoriate,{id: @under_review.to_param}
    assert_response :success
  end

end
