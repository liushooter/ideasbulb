 $('#alert').remove()
<% if @topic.errors.any? %>
 $('#new-topic').before('<%= errors_msg_tag(@topic) %>')
<% else %>
 $("#del-topic-<%= @topic.id %>").parent().parent().remove()
<% end %>
