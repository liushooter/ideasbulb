module IdeasHelper

  def status_span_tag(idea)
    content_tag :span,I18n.t("app.idea.status.#{idea.status}"),:class => "bold"
  end

  def handle_idea_button(idea)
    if (can? :handle,idea) && idea.status != IDEA_STATUS_LAUNCHED
      case idea.status
      when IDEA_STATUS_UNDER_REVIEW
        button = link_to(I18n.t("app.idea.handle.#{idea.status}"),handle_idea_path(idea,:status => IDEA_STATUS_REVIEWED_SUCCESS),:class => "btn btn-warning btn-large",:method => :put)
      when IDEA_STATUS_REVIEWED_SUCCESS
        button = link_to(I18n.t("app.idea.handle.#{idea.status}"),handle_idea_path(idea,:status => IDEA_STATUS_LAUNCHED),:class => "btn btn-warning btn-large",:method => :put) 
      end
      content_tag(:div,button,:class =>"head-title well") if button
    end
  end

  def unfavor_idea_button(idea)
	link_to I18n.t("app.idea.unfavoriate"),unfavoriate_idea_path(idea),:remote => true,:id => "favor-link-#{idea.id}",:class=>"btn btn-danger"
  end

  def favor_idea_button(idea)
	link_to I18n.t("app.idea.favoriate"),favoriate_idea_path(idea),:remote => true,:id => "favor-link-#{idea.id}",:class=>"btn btn-success"
  end

  def favor_unfavor_button(idea)
    if can? :favoriate,idea
      content_tag :div,idea.favorers.exists?(current_user.id)?unfavor_idea_button(idea):favor_idea_button(idea),:class=>"btn-group"
    end
  end

  def edit_idea_link(idea)
    if (can? :update,idea) && current_user.id == idea.user.id && idea.status!=IDEA_STATUS_LAUNCHED
      content_tag :li,link_to(I18n.t("app.idea.edit"),"javascript:;","data-idea"=> idea.id,:class=>"edit-idea-link")
    end
  end

end
