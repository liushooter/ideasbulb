<% if @comment.errors.empty? %>
 $("#comment-<%= @comment.id %>").remove()
 $("#edit-comment-<%= @comment.id %>").remove()
<% end %>
