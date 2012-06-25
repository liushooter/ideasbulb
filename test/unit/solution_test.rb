require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  def setup
    @solution = solutions(:user_tom_solution_reviewed_success)    
  end

  test "validate empty solution" do
    solution = Solution.new
    assert solution.invalid?
    assert solution.errors[:title].any?
    assert solution.errors[:content].any?
  end

  test "validate solution content maxlength" do
    content = ""
    10.times do
      content = @solution.content + content
    end
    @solution.content = content
    assert @solution.valid?
    assert @solution.errors[:content].empty?
    @solution.content = @solution.content + "a"
    assert @solution.invalid?
    assert @solution.errors[:content].any?
  end

  test "validate solution title maxlength" do
    title = ""
    6.times do
      title = @solution.title + title
    end
    @solution.title = title
    assert @solution.valid?
    assert @solution.errors[:title].empty?
    @solution.title = @solution.title + "a"
    assert @solution.invalid?
    assert @solution.errors[:title].any?
  end

  test "validate update solution points" do
    points = 0
    @solution.votes.each do |vote|
      points = points + (vote.like ? 1 : -1)
    end
    Solution.update_points(@solution.id)
    assert_equal points,Solution.find(@solution.id).points
  end
end
