<% if @solution.errors.empty? %>
 $("#solution-<%= @solution.id %>").remove()
 $("#edit-solution-<%= @solution.id %>").remove()
<% end %>
