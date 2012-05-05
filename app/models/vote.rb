class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :solution

  before_save do |vote|
    check_status(vote.solution.idea.status,'app.error.vote.voting')
  end

  before_destroy do |vote|
    check_status(vote.solution.idea.status,'app.error.vote.voting')
  end

  after_save do |vote|
    Solution.update_points(vote.solution_id)
    Idea.update_solutions_points(vote.solution.idea_id)
  end

  after_destroy do |vote|
    Solution.update_points(vote.solution_id)
    Idea.update_solutions_points(vote.solution.idea_id)
  end
  
  after_create do |vote|
    User.update_points(vote.user_id,USER_VOTE_POINTS)
  end

  private
  def check_status(status,error)
    if status != IDEA_STATUS_REVIEWED_SUCCESS
      errors.add(:base,I18n.t(error))      
      return false
    end
  end 
end
