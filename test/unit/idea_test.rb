require 'test_helper'

class IdeaTest < ActiveSupport::TestCase
  def setup
    @under_review = ideas(:under_review)
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
      title = @under_review.title + title
    end
    @under_review.title = title
    assert @under_review.valid?
    assert @under_review.errors[:title].empty?
    @under_review.title = @under_review.title + "a"
    assert @under_review.invalid?
    assert @under_review.errors[:title].any?
  end

  test "validate idea description maxlength" do
    description = ""
    20.times do
      description = @under_review.description + description
    end
    @under_review.description = description
    assert @under_review.valid?
    assert @under_review.errors[:description].empty?
    @under_review.description = @under_review.description + "a"
    assert @under_review.invalid?
    assert @under_review.errors[:description].any?
  end

  test "validate idea tags max number" do
    @under_review.tag_names = "design ux feel"
    assert @under_review.valid?
    assert @under_review.errors[:tags].empty?
    @under_review.tag_names = "design  ux  feel "
    assert @under_review.valid?
    assert @under_review.errors[:tags].empty?
    @under_review.tag_names = "design ux feel other"
    assert @under_review.invalid?
    assert @under_review.errors[:tags].any?
  end
end
