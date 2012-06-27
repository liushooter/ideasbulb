<% unless @solution.errors.any? %>
  $("#unpick-link-<%= @solution.id %>").replaceWith('<%= pick_solution_link(@solution) %>').css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
<% end %>
