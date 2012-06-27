 addDiv = $("#add-comment-<%= @idea_id %>")
 form = addDiv.find("form")
 form.prev().remove()
<% if @comment.errors.any? %>
 form.before('<%= errors_msg_tag @comment %>')
<% else %>
 addDiv.hide()
 form[0].reset()
 insertComment('<%= escape_javascript( render(:partial => @comment )) %>',"#before-comments-<%= @idea_id %>","after",true)
 $('#action-button-<%= @idea_id %>').show()
<% end %>
