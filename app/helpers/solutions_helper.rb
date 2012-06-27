module SolutionsHelper
  def new_solution_button(idea)
    if (can? :create,Solution) && idea.status != IDEA_STATUS_LAUNCHED
      content_tag :div,:class=>"btn-group" do
        button_tag I18n.t("app.solution.new"),:class=>"solution-btn btn btn-primary","data-idea"=> idea.id
      end
    end
  end

  def edit_solution_link(solution)
    idea = solution.idea
    if (can? :update,solution) && current_user.id == solution.user.id && idea.status != IDEA_STATUS_LAUNCHED
      content_tag :li,link_to(I18n.t("app.solution.edit"),"javascript:;","data-solution"=> solution.id,:class=>"edit-solution-link"),:style=>"margin-top:10px"
    end
  end

  def del_solution_link(solution)
    idea = solution.idea
    if (can? :destroy,solution) && current_user.id == solution.user.id && idea.status != IDEA_STATUS_LAUNCHED
      content_tag :li,link_to(I18n.t("app.solution.del"),solution,:method => :delete,:remote => true,"data-solution"=> solution.id,:id=>"del-solution-#{solution.id}")
    end 
  end

  def vote_solution_link(path,method,solution_id,vote,like)
    content_tag :li,:id => "#{like ? 'like' : 'unlike'}-solution-#{solution_id}" do
      link_to path,:method=> method,:remote => true,"data-original-title"=>I18n.t("app.solution.#{vote ? 'vote' : 'unvote' }.#{like ? 'like' : 'unlike' }"),"data-placement"=>"right",:class => "tip-link" do
        content_tag :span,content_tag(:i,"",:class => (like ? "icon-thumbs-up" : "icon-thumbs-down")+" icon-white" ),:class => "label#{vote ? '' : ' label-info'}"
      end
    end  
  end

  def vote_unvote_solution_link(solution)
    if user_signed_in? && solution.idea.status == IDEA_STATUS_REVIEWED_SUCCESS
      vote = Vote.find_by_solution_id_and_user_id(solution,current_user)
      if vote
        if vote.like
          vote_solution_link(vote_path(vote),"delete",solution.id,false,true)+vote_solution_link(vote_path(vote,:like => false),"put",solution.id,true,false)
        else          
          vote_solution_link(vote_path(vote,:like => true),"put",solution.id,true,true)+vote_solution_link(vote_path(vote),"delete",solution.id,false,false)
        end
      else
        vote_solution_link(votes_path(:solution_id => solution.id,:like => true),"post",solution.id,true,true)+vote_solution_link(votes_path(:solution_id => solution.id,:like => false),"post",solution.id,true,false)
      end     
    end 
  end

  def pick_solution_link(solution)
	link_to I18n.t("app.solution.pick"),pick_solution_path(solution),:method=>:put,:remote => true,:id => "pick-link-#{solution.id}",:class=>"btn btn-success"
  end

  def unpick_solution_link(solution)
	link_to I18n.t("app.solution.unpick"),unpick_solution_path(solution),:method=>:put,:remote => true,:id => "unpick-link-#{solution.id}",:class=>"btn btn-danger"
  end

  def pick_unpick_link(solution)
    if solution.pick
      unpick_solution_link(solution)
    else
      pick_solution_link(solution)
    end
  end
end
