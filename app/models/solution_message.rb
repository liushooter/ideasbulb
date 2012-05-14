# encoding: utf-8
class SolutionMessage
  @queue = :message

  def self.perform(solution_id)
    solution = Solution.find(solution_id)
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

end
