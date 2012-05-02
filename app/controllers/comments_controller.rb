class CommentsController < ApplicationController
  authorize_resource

  def create
    @comment = Comment.new(params[:comment])
    @comment.user = current_user
    @idea_id = params[:idea_id] 
    @comment.idea = Idea.find(@idea_id)
    @comment.save
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update_attributes(params[:comment])
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
  end
end
