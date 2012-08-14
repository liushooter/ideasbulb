class IdeasController < ApplicationController
  authorize_resource

  def index
    @topics = Topic.all
    @tags = Tag.where("ideas_count>0").order("ideas_count desc") 
  end

  def search
    params[:q] = params[:q].gsub(SEARCH_SOLR_FILTER,'')
    @ideas = nil
    if !params[:q].empty?
      search = Idea.search do
        fulltext params[:q] do
          boost_fields :title => 2.0,:description => 1.0
        end
        paginate :page => params[:page],:per_page => Idea.per_page 
      end
      @ideas = search.results
    end
    @idea_query = params[:q]
    render :layout => "list"
  end

  def promotion
    ideas=Idea.search do
      keywords params[:query]
      paginate :per_page => 10 
    end.results
    render :json => {:query=>params[:query],:suggestions => ideas.collect{|idea| idea.title},:data => ideas.collect{|idea| idea.id} }.to_json
  end
  
  def show
    @idea = Idea.includes(:tags,:user,:topic,:comments,:solutions,:favorers).find(params[:id])
    @idea_page = true
    render :layout => "list"
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
      check_status(IDEA_STATUS_REVIEWED_SUCCESS)
    when IDEA_STATUS_REVIEWED_SUCCESS
      if @idea.solutions.where(:pick => true).count == 0
        flash[:alert] = I18n.t('app.error.idea.pick_solution') 
      else
        check_status(IDEA_STATUS_LAUNCHED)
      end
    when IDEA_STATUS_LAUNCHED 
      flash[:alert] = I18n.t('app.error.idea.launched') 
    end
    if !flash[:alert]
      @idea.is_handle = true
      @idea.update_attributes(:status => params[:status])
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
    elsif params[:tag_id] 
      @ideas = Tag.find(params[:tag_id]).ideas.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).where(conditions).order(sort)
    else
      @ideas = Idea.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).where(conditions).order(sort)
    end
    render :layout => false
  end

  def favoriate
    @idea = Idea.find(params[:id])
    @idea.favorers << current_user
  end

  def unfavoriate
    @idea = Idea.find(params[:id])
    @idea.favorers.destroy(current_user)
  end

  def more_solutions
    page_size = 5
    @idea = Idea.find(params[:id])
    @page = params[:page].to_i
    offset = @page*page_size+2
    @have_more = @idea.solutions.count > offset+page_size
    @solutions =  @idea.solutions.limit(page_size).offset(offset)
  end

  def more_comments
    page_size = 5
    @idea = Idea.find(params[:id])
    @page = params[:page].to_i
    offset = @page*page_size+2
    @have_more = @idea.comments.count > offset+page_size
    @comments =  @idea.comments.limit(page_size).offset(offset)
  end

  private
  def check_status(status)
    if params[:status] != status
        flash[:alert] = I18n.t('app.error.idea.status',:status => I18n.t("app.idea.status.#{status}"))
    end
  end

end
