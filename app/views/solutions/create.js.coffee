 addDiv = $("#add-solution-<%= @idea_id %>") 
 form = addDiv.find("form")
 form.prev().remove()
<% if @solution.errors.any? %> 
 form.before('<%= errors_msg_tag @solution %>')
<% else %>
 addDiv.hide()
 solution = $('<%= escape_javascript( render(:partial => @solution )) %>')
 solution.find('.edit-solution-link').click -> showEditForm('solution',this)
 solution.find('ul.solution-actions').tooltip selector: "a.tip-link"
 form[0].reset()
 solution.insertAfter("#after-solutions-<%= @idea_id %>")
 $(solution[0]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
 $('#action-button-<%= @idea_id %>').show()
<% end %>
