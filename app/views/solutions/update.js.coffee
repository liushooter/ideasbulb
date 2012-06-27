 form=$('#edit_solution_<%= @solution.id %>')
 form.prev().remove()
<% if @solution.errors.any? %>
 form.before('<%= errors_msg_tag @solution %>')
<% else %>
 $('#edit-solution-<%= @solution.id %>').remove()
 insertSolution('<%= escape_javascript( render(:partial => @solution )) %>',"#solution-<%= @solution.id %>","replace",true)
<% end %>
