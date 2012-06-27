 container = $("#more-comments-<%= @idea.id %>").empty()
<% if @have_more %>
 container.append('<div class="span7 show-more"><%= link_to "查看更多评论",more_comments_idea_path(@idea,:page => @page+1),:remote=>true %></div>')
<% end %>
<% @comments.each do |comment| %>
 insertComment('<%= escape_javascript( render(:partial => comment )) %>',"#after-comments-<%= @idea.id %>","before",true)
<% end %>
