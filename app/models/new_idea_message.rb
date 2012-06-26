# encoding: utf-8
class NewIdeaMessage
  @queue = :message

  def self.perform(idea_id)
    idea = Idea.find(idea_id)
    creator = idea.user
    users = []
    User.where(:admin => true).each {|user| users << user if idea.user_id != user.id }
    users.each do |user| 
      Message.create(:user => user,:content => "#{creator.username} 发布了新主意 #{idea.title}",:link => "/ideas/#{idea.id}")
      MessageMailer.new_idea_email(user,creator,idea).deliver
    end
  end

end
