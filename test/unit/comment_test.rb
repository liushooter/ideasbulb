require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:user_tom_comment_under_review)    
  end

  test "validate empty comment" do
    comment = Comment.new
    assert comment.invalid?
    assert comment.errors[:content].any?
  end

  test "validate comment content maxlength" do
    content = ""
    10.times do
      content = @comment.content + content
    end
    @comment.content = content
    assert @comment.valid?
    assert @comment.errors[:content].empty?
    @comment.content = @comment.content + "a"
    assert @comment.invalid?
    assert @comment.errors[:content].any?
  end

end
