<% unless @solution.errors.any? %>
  $("#pick-link-<%= @solution.id %>").replaceWith('<%= unpick_solution_link(@solution) %>').css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
<% end %>
