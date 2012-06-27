require 'test_helper'

class IdeasControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user_tom_under_review = ideas(:user_tom_under_review)
    @user_tom_reviewed_success = ideas(:user_tom_reviewed_success)
    @user_tom_launched = ideas(:user_tom_launched)
    @user_zhang_reviewed_success = ideas(:user_zhang_reviewed_success)
    @user_tom_solution_reviewed_success = solutions(:user_tom_solution_reviewed_success)
    @user_zhang_solution_reviewed_success = solutions(:user_zhang_solution_reviewed_success)
    @admin_jack = users(:admin_jack)
    @user_tom = users(:user_tom)
    @user_zhang = users(:user_zhang)
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
  
  test "everybody show idea" do
    get :show, id: @user_tom_under_review.to_param
    assert_response :success
    assert_not_nil assigns(:idea)
    assert assigns(:idea_page)
  end

  test "everybody get more solutions" do
    xhr :get,:more_solutions,{:id=> @user_tom_under_review.id,:page => 0}
    assert_response :success
  end

  test "everybody get more comments" do
    xhr :get,:more_comments,{:id=> @user_tom_under_review.id,:page => 0}
    assert_response :success
  end

  test "everybody not create" do
    xhr :post,:create
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user create valid idea with no tag" do
    sign_in @user_tom
    @user_tom_under_review.tag_names = ""
    assert_difference('Idea.count') do
      xhr :post,:create,{idea: @user_tom_under_review.attributes}
    end
    assert_response :success
  end

  test "login user create valid idea with tag" do
    sign_in @user_tom
    @user_tom_under_review.tag_names = "test good"
    assert_difference('Idea.count') do
      xhr :post,:create,{idea: @user_tom_under_review.attributes}
    end
    assert_response :success
  end

  test "login user create invalid idea" do
    sign_in @user_tom
    @user_tom_under_review.title = nil
    assert_no_difference('Idea.count') do
      xhr :post,:create,{idea: @user_tom_under_review.attributes}
    end
    assert assigns(:idea).errors.any?
  end

  test "everybody not update idea" do
    xhr :put,:update,{ id: @user_tom_under_review.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user update own valid idea" do
    sign_in @user_tom
    title = "updated title" 
    @user_tom_under_review.title = title
    xhr :put,:update,{id: @user_tom_under_review.to_param,idea:@user_tom_under_review.attributes}
    assert assigns(:idea).errors.empty?
    assert_equal title,Idea.find(@user_tom_under_review.id).title 
    assert_response :success
  end

  test "login user update own invalid idea" do
    sign_in @user_tom
    @user_tom_under_review.title = ""
    xhr :put,:update,{id: @user_tom_under_review.to_param,idea:@user_tom_under_review.attributes}
    assert assigns(:idea).errors.any?
    assert_response :success
  end

  test "login user not update other idea" do
    sign_in @user_zhang
    assert_raise(ActiveRecord::RecordNotFound){
      xhr :put,:update, id: @user_tom_under_review.to_param, idea: @user_tom_under_review.attributes
    }
  end

  test "login user not update launched idea" do
    sign_in @user_tom
    title = "launched title" 
    @user_tom_launched.title = title
    assert_no_difference('Idea.count') do
      xhr :put,:update,{id: @user_tom_launched.to_param,idea:@user_tom_launched.attributes},
    end
    assert assigns(:idea).errors.any?
    assert_not_equal title,Idea.find(@user_tom_launched.id).title 
    assert_response :success
  end

  test "everybody not handle idea" do
    post :handle,{ id: @user_tom_under_review.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user not handle idea" do
    sign_in @user_tom
    post :handle,{ id: @user_tom_under_review.to_param}
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end
  
  test "admin reviewed success valid idea" do
    sign_in @admin_jack
    post :handle,{id: @user_tom_under_review.to_param,:status => IDEA_STATUS_REVIEWED_SUCCESS}
    assert_redirected_to idea_path(assigns(:idea))
    assert_nil flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_SUCCESS,Idea.find(@user_tom_under_review.id).status
  end
  
  test "admin reviewed success invalid idea" do
    sign_in @admin_jack
    post :handle,{id: @user_tom_under_review.to_param,:status => IDEA_STATUS_LAUNCHED}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{IDEA_STATUS_REVIEWED_SUCCESS}")),flash[:alert]
    assert_equal IDEA_STATUS_UNDER_REVIEW,Idea.find(@user_tom_under_review.id).status
  end

  test "admin launched valid idea" do
    sign_in @admin_jack
    post :handle,{id: @user_tom_reviewed_success.to_param,:status => IDEA_STATUS_LAUNCHED}
    assert_redirected_to idea_path(assigns(:idea))
    assert_nil flash[:alert]
    assert_equal IDEA_STATUS_LAUNCHED,Idea.find(@user_tom_reviewed_success.id).status
  end

  test "admin launched invalid idea" do
    sign_in @admin_jack
    post :handle,{id: @user_tom_reviewed_success.to_param,:status => IDEA_STATUS_UNDER_REVIEW}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{IDEA_STATUS_LAUNCHED}")),flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_SUCCESS,Idea.find(@user_tom_reviewed_success.id).status
  end

  test "admin launched idea with no solution" do
    sign_in @admin_jack
    post :handle,{id: @user_zhang_reviewed_success.to_param,:status => IDEA_STATUS_LAUNCHED}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.pick_solution'),flash[:alert]
    assert_equal IDEA_STATUS_REVIEWED_SUCCESS,Idea.find(@user_tom_reviewed_success.id).status
  end

  test "admin not handle launched idea" do
    sign_in @admin_jack
    post :handle,{id: @user_tom_launched.to_param}
    assert_redirected_to idea_path(assigns(:idea))
    assert_equal I18n.t('app.error.idea.launched'),flash[:alert]
    assert_equal IDEA_STATUS_LAUNCHED,Idea.find(@user_tom_launched.id).status
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
    xhr :post,:favoriate,id: @user_tom_under_review.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "everybody not unfavoriate idea" do
    xhr :post,:unfavoriate,id: @user_tom_under_review.to_param
    assert_redirected_to root_path
    assert_equal I18n.t('unauthorized.manage.all'),flash[:alert]
  end

  test "login user favoriate idea" do
    sign_in @user_zhang
    xhr :post, :favoriate,{id: @user_tom_under_review.to_param}
    assert_response :success
  end

  test "login user unfavoriate idea" do
    sign_in @user_zhang
    xhr :post, :unfavoriate,{id: @user_tom_under_review.to_param}
    assert_response :success
  end

end
