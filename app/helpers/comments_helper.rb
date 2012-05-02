module CommentsHelper
  def new_comment_button(idea)
    if can? :create,Comment
      content_tag :div,:class=>"btn-group" do
        button_tag I18n.t("app.comment.new"),:class=>"comment-btn btn btn-info","data-idea"=> idea.id
      end
    end
  end

  def edit_comment_link(comment)
    if (can? :update,comment) && current_user.id == comment.user.id
      content_tag :li,link_to(I18n.t("app.comment.edit"),"javascript:;","data-comment"=> comment.id,:class=>"edit-comment-link")
    end
  end
  
  def del_comment_link(comment)
   if (can? :destroy,comment) && current_user.id == comment.user.id
      content_tag :li,link_to(I18n.t("app.comment.del"),comment,:method => :delete,:remote => true,"data-comment"=> comment.id,:id=>"del-comment-#{comment.id}")
    end 
  end
end
