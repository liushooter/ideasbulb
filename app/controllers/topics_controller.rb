class TopicsController < ApplicationController
  authorize_resource
  layout "admin"

  def show
    @topic = Topic.find_by_name!(params[:id])
    @ideas = @topic.ideas.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).where("status = ?",IDEA_STATUS_REVIEWED_SUCCESS).order(hot_sort)
    render :layout => "list"
  end

  def index
    @topics = Topic.order("created_at desc")
  end

  def new
    @topic = Topic.new    
  end

  def create
    @topic = Topic.new(params[:topic])
    if @topic.save
      redirect_to :action => :index
    else
      render :new
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(params[:topic])
      redirect_to :action => :index
    else
      render :edit
    end
  end
end
