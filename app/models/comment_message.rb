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
      Message.create(:user => user,:content => "\"#{creator.username}\"评论了主意\"#{idea.title}\"",:link => "/ideas/#{idea.id}")
      MessageMailer.make_comment_email(user,creator,comment,idea).deliver
    end
  end
end
