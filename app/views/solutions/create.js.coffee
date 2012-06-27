 addDiv = $("#add-solution-<%= @idea_id %>")
 form = addDiv.find("form")
 form.prev().remove()
<% if @solution.errors.any? %>
 form.before('<%= errors_msg_tag @solution %>')
<% else %>
 addDiv.hide()
 form[0].reset()
 insertSolution('<%= escape_javascript( render(:partial => @solution )) %>',"#before-solutions-<%= @idea_id %>","after",true)
 $('#action-button-<%= @idea_id %>').show()
<% end %>
