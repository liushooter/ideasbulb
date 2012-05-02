 form=$('#edit_solution_<%= @solution.id %>')
 form.prev().remove()
<% if @solution.errors.any? %>
 form.before('<%= errors_msg_tag @solution %>')
<% else %>
 solution = $('<%= escape_javascript( render(@solution)) %>')
 solution.find('.edit-solution-link').click -> showEditForm('solution',this)
 solution.find('ul.solution-actions').tooltip selector: "a.tip-link"
 $('#edit-solution-<%= @solution.id %>').remove()
 $(solution[0]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
 $('#solution-<%= @solution.id %>').replaceWith(solution)
<% end %>
