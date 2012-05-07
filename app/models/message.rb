# encoding: utf-8
class Message < ActiveRecord::Base
  belongs_to :user

  def self.make_solution_message(solution)
    idea = solution.idea
    creator = solution.user
    users = []
    users << idea.user
    idea.favorers.each {|user| users << user if users[0].id != user.id }
    users.each do |user| 
      Message.create(:user => user,:content => "<a href='/users/#{creator.id}'>#{creator.username}</a> 建议 <span class='plain'>#{solution.title}</span>，关于 <a href='/ideas/#{idea.id}'>#{idea.title}</a>")
      MessageMailer.make_solution_email(user,creator,solution,idea).deliver
    end
  end

  def self.make_comment_message(comment)
    idea = comment.idea
    creator = comment.user
    users = []
    users << idea.user
    idea.favorers.each {|user| users << user if users[0].id != user.id }
    users.each do |user| 
      Message.create(:user => user,:content => "<a href='/users/#{creator.id}'>#{creator.username}</a> 评论了 <a href='/ideas/#{idea.id}'>#{idea.title}</a>")
      MessageMailer.make_comment_email(user,creator,comment,idea).deliver
    end
  end
end
