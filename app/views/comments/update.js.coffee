 form=$('#edit_comment_<%= @comment.id %>')
 form.prev().remove()
<% if @comment.errors.any? %>
 form.before('<%= errors_msg_tag @comment %>')
<% else %>
 comment = $('<%= escape_javascript( render(@comment)) %>')
 comment.find('.edit-comment-link').click -> showEditForm('comment',this)
 $('#edit-comment-<%= @comment.id %>').remove()
 $(comment[0]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
 $('#comment-<%= @comment.id %>').replaceWith(comment)
<% end %>
