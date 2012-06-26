# encoding: utf-8
class HandleIdeaMessage
  @queue = :message

  def self.perform(idea_id)
    idea = Idea.find(idea_id)
    users = []
    users << idea.user
    idea.favorers.each {|user| users << user if idea.user_id != user.id }
    status = I18n.t("app.idea.status.#{idea.status}")
    users.each do |user| 
      Message.create(:user => user,:content => "主意\"#{idea.title}\"的状态被修改为\"#{status}\"",:link => "/ideas/#{idea.id}")
      MessageMailer.handle_idea_email(user,idea).deliver
    end
  end

end
