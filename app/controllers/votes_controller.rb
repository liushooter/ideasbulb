class VotesController < ApplicationController
  authorize_resource

  def create
    @vote = Vote.new(:solution_id => params[:solution_id],:user_id=>current_user.id,:like => params[:like])
    @vote.save
  end

  def update
    @vote = current_user.votes.find(params[:id])
    @vote.like = params[:like]
    @vote.save
    render "create"
  end

  def destroy
    @vote = current_user.votes.find(params[:id])
    @vote.destroy
  end

end
