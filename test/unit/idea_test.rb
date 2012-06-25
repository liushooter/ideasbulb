require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
  def setup
    @idea = ideas(:user_tom_under_review)
  end    

  test "validate empty idea" do
    idea = Idea.new
    assert idea.invalid?
    assert idea.errors[:title].any?
    assert idea.errors[:description].any?
  end

  test "validate idea title maxlength" do
    title = ""
    12.times do
      title = @idea.title + title
    end
    @idea.title = title
    assert @idea.valid?
    assert @idea.errors[:title].empty?
    @idea.title = @idea.title + "a"
    assert @idea.invalid?
    assert @idea.errors[:title].any?
  end

  test "validate idea description maxlength" do
    description = ""
    20.times do
      description = @idea.description + description
    end
    @idea.description = description
    assert @idea.valid?
    assert @idea.errors[:description].empty?
    @idea.description = @idea.description + "a"
    assert @idea.invalid?
    assert @idea.errors[:description].any?
  end

  test "validate idea tags max number" do
    @idea.tag_names = "design ux feel"
    assert @idea.valid?
    assert @idea.errors[:tags].empty?
    @idea.tag_names = "design  ux  feel "
    assert @idea.valid?
    assert @idea.errors[:tags].empty?
    @idea.tag_names = "design ux feel other"
    assert @idea.invalid?
    assert @idea.errors[:tags].any?
  end
end
