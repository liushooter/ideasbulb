# encoding: utf-8
class CommentMessage
  @queue = :message

  def self.perform(comment_id)
    comment = Comment.find(comment_id)
    idea = comment.idea
    creator = comment.user
    users = []
    users << idea.user if creator.id != idea.user_id
    idea.favorers.each {|user| users << user if creator.id != user.id && idea.user_id != user.id }
    users.each do |user| 
      Message.create(:user => user,:content => "<a href='/users/#{creator.id}'>#{creator.username}</a> 评论了 <a href='/ideas/#{idea.id}'>#{idea.title}</a>")
      MessageMailer.make_comment_email(user,creator,comment,idea).deliver
    end
  end
end
