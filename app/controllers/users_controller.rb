class UsersController < ApplicationController
  authorize_resource

  def index
    if params[:q] && !params[:q].empty?
      @users = User.where("username like ? OR email like ?","%#{params[:q]}%","%#{params[:q]}%").paginate(:page => params[:page]).order("admin desc")
    else
      @users = User.paginate(:page => params[:page]).order("admin desc")
    end
    render :layout => "admin"
  end

  def show
    @user = User.find_by_username(params[:id])
    @ideas = @user.ideas.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).order(hot_sort)
    render :layout => "list"
  end

  def authority
    @user = User.find(params[:id])
    @user.admin = params[:admin]
    @user.save(:validate => false)
  end

  def edit 
    @user = User.find(params[:id])
    if current_user.id != @user.id 
      redirect_to root_path, :alert => I18n.t('unauthorized.manage.all')
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user), :notice => I18n.t('app.notice.user.edit')
    else
      render action:'edit'
    end
  end

  def inbox
    @messages = current_user.messages.paginate(:page => params[:page]).order("readed,created_at DESC")
    render :layout => false if request.xhr?
  end

end
