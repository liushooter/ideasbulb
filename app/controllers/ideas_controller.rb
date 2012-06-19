class IdeasController < ApplicationController
  authorize_resource

  def index
    @status = params[:status ] ? params[:status] : IDEA_STATUS_REVIEWED_SUCCESS
    conditions = {}
    conditions[:status] = @status 
    if params[:topic_id]
      @topic_id = params[:topic_id].to_i
      conditions[:topic_id] = @topic_id 
    end
    @ideas = Idea.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).where(conditions).order(hot_sort)
    render :layout => "list"
  end

  def search
    search = Idea.search do
      keywords params[:q]
      paginate :page => params[:page],:per_page => Idea.per_page 
    end
    @ideas = search.results
    @query = params[:q]
  end

  def promotion
    @ideas=Idea.search do
      keywords params[:title]
      paginate :per_page => 20 
    end.results
    render :layout => false
  end
  
  def show
    @idea = Idea.includes(:tags,:user,:topic,:comments,:solutions,:favorers).find(params[:id])
    @idea_page = true
  end

  def create
    @idea = Idea.new(params[:idea])
    @idea.status = IDEA_STATUS_UNDER_REVIEW 
    @idea.user = current_user
    @idea.save
  end

  def update
    @idea = current_user.ideas.find(params[:id])
    @idea.update_attributes(params[:idea])
  end

  def handle
    @idea = Idea.find(params[:id])
    case @idea.status
    when IDEA_STATUS_UNDER_REVIEW
      if params[:fail]
        check_status(IDEA_STATUS_REVIEWED_FAIL)
      else
        check_status(IDEA_STATUS_REVIEWED_SUCCESS)
      end
    when IDEA_STATUS_REVIEWED_FAIL
      check_status(IDEA_STATUS_UNDER_REVIEW)
    when IDEA_STATUS_REVIEWED_SUCCESS
      if !params[:solutionIds]
        flash[:alert] = I18n.t('app.error.idea.pick_solution') 
      else
        check_status(IDEA_STATUS_IN_THE_WORKS)
      end
    when IDEA_STATUS_IN_THE_WORKS
      check_status(IDEA_STATUS_LAUNCHED)
    when IDEA_STATUS_LAUNCHED 
      flash[:alert] = I18n.t('app.error.idea.launched') 
    end
    if !flash[:alert]
      @idea.is_handle = true
      Solution.find(params[:solutionIds]).each{|solution| solution.update_attribute(:pick,true)} if params[:solutionIds]
      @idea.update_attributes(:status => params[:status],:fail => params[:fail])
    end
    redirect_to @idea 
  end

  def tab
    conditions = {}
    conditions[:status] = params[:status] if params[:status] 
    conditions[:topic_id] = params[:topic_id] if params[:topic_id]
    conditions[:user_id] = params[:user_id] if params[:user_id]
    if IDEAS_SORT_HOT == params[:sort]
      sort = hot_sort 
    elsif IDEAS_SORT_NEWEST == params[:sort]
      sort = "ideas.created_at DESC"
    else
      sort = hot_sort 
    end
    if params[:favorer_id]
      @ideas = User.find(params[:favorer_id]).favored_ideas.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).where(conditions).order(sort)
    else
      @ideas = Idea.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).where(conditions).order(sort)
    end
    render :layout => false
  end

  def tag
    @tag = Tag.find(params[:tag_id])
    @ideas = @tag.ideas.paginate(:page => params[:page])
  end

  def favoriate
    @idea = Idea.find(params[:id])
    @idea.favorers << current_user
  end

  def unfavoriate
    @idea = Idea.find(params[:id])
    @idea.favorers.destroy(current_user)
  end

  private
  def check_status(status)
    if params[:status] != status
        flash[:alert] = I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{status}"))
    end
  end

  def hot_sort
    "(2*`solutions_count`+`comments_count`+`solutions_points`)/POW(TIMESTAMPDIFF(HOUR,`ideas`.`created_at`,NOW())+2,1.5) DESC" 
  end
end
