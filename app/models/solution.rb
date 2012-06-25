class Solution < ActiveRecord::Base
  belongs_to :user
  belongs_to :idea,:counter_cache => true
  has_many :voters,:through => :votes,:source =>:user
  has_many :votes

  validates :content,:presence =>true,:length => {:maximum => 1000}
  validates :title,:presence =>true,:length => {:maximum => 60}

  before_create do |solution|
    check_status(solution.idea.status,'app.error.solution.create')
  end

  before_update do |solution|
    check_status(solution.idea.status,'app.error.solution.update')
  end

  before_destroy  do |solution|
    check_status(solution.idea.status,'app.error.solution.destroy')
  end

  after_create do |solution|
    User.update_points(solution.user_id,USER_NEW_SOLUTION_POINTS)
    Resque.enqueue(SolutionMessage, solution.id)
  end

  def self.update_points(solution_id)
    connection.update("UPDATE solutions SET points = 
    (SELECT COUNT( * ) FROM `votes` WHERE `solution_id` = #{solution_id} AND `like` =1 )
    - (SELECT COUNT( * ) FROM `votes` WHERE `solution_id` = #{solution_id} AND `like` =0)
    WHERE id= #{solution_id}")
  end

  private
  def check_status(status,error)
    if status == IDEA_STATUS_LAUNCHED 
      errors.add(:base,I18n.t(error))      
      return false
    end
  end
end
