 form=$('#edit_comment_<%= @comment.id %>')
 form.prev().remove()
<% if @comment.errors.any? %>
 form.before('<%= errors_msg_tag @comment %>')
<% else %>
 $('#edit-comment-<%= @comment.id %>').remove()
 insertComment('<%= escape_javascript( render(:partial => @comment )) %>',"#comment-<%= @comment.id %>","replace",true)
<% end %>
