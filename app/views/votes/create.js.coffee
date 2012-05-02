<% if @vote.errors.empty? %>
like_li=$('#like-solution-<%= @vote.solution_id %>')
like_li.find('a').tooltip('hide')
unlike_li=$('#unlike-solution-<%= @vote.solution_id %>')
unlike_li.find('a').tooltip('hide')
<% if @vote.like %>
like_li.replaceWith('<%= vote_solution_link(vote_path(@vote),"delete",@vote.solution_id,false,true) %>')
unlike_li.replaceWith('<%= vote_solution_link(vote_path(@vote,:like => false),"put",@vote.solution_id,true,false) %>')
<% else %>
like_li.replaceWith('<%= vote_solution_link(vote_path(@vote,:like => true),"put",@vote.solution_id,true,true) %>')
unlike_li.replaceWith('<%= vote_solution_link(vote_path(@vote),"delete",@vote.solution_id,false,false) %>')
<% end %>
$('#solution-points-<%= @vote.solution_id %>').text('<%= @vote.solution( force_reload = true ).points %>分')
$('#solution-<%= @vote.solution_id %>').css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
<% end %>
