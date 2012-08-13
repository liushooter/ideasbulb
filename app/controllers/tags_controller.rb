class TagsController < ApplicationController
  authorize_resource

  def show
    @tag = Tag.find_by_name!(params[:id])
    @ideas = @tag.ideas.paginate(:page => params[:page]).includes(:tags,:user,:topic,:comments,:solutions).where("status = ?",IDEA_STATUS_REVIEWED_SUCCESS).order(hot_sort)
    render :layout => "list"
  end
end
