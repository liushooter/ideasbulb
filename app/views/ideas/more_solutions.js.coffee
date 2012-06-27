 container = $("#more-solutions-<%= @idea.id %>").empty()
<% if @have_more %>
 container.append('<div class="span7 show-more"><%= link_to "查看更多方案",more_solutions_idea_path(@idea,:page => @page+1),:remote=>true %></div>')
<% end %>
<% @solutions.each do |solution| %>
 insertSolution('<%= escape_javascript( render(:partial => solution )) %>',"#after-solutions-<%= @idea.id %>","before",true)
<% end %>
