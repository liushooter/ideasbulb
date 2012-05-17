# encoding: utf-8
class SolutionMessage
  @queue = :message

  def self.perform(solution_id)
    solution = Solution.find(solution_id)
    idea = solution.idea
    creator = solution.user
    users = []
    users << idea.user if creator.id != idea.user_id
    idea.favorers.each {|user| users << user if creator.id != user.id && idea.user_id != user.id }
    users.each do |user| 
      Message.create(:user => user,:content => "#{creator.username} 给 #{idea.title} 提了建议",:link => "/ideas/#{idea.id}")
      MessageMailer.make_solution_email(user,creator,solution,idea).deliver
    end
  end

end
