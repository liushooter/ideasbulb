require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  def setup
    @solution_one = solutions(:solution_one)    
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
      content = @solution_one.content + content
    end
    @solution_one.content = content
    assert @solution_one.valid?
    assert @solution_one.errors[:content].empty?
    @solution_one.content = @solution_one.content + "a"
    assert @solution_one.invalid?
    assert @solution_one.errors[:content].any?
  end

  test "validate solution title maxlength" do
    title = ""
    6.times do
      title = @solution_one.title + title
    end
    @solution_one.title = title
    assert @solution_one.valid?
    assert @solution_one.errors[:title].empty?
    @solution_one.title = @solution_one.title + "a"
    assert @solution_one.invalid?
    assert @solution_one.errors[:title].any?
  end

  test "validate update solution points" do
    points = 0
    @solution_one.votes.each do |vote|
      points = points + (vote.like ? 1 : -1)
    end
    Solution.update_points(@solution_one.id)
    assert_equal points,Solution.find(@solution_one.id).points
  end
end
