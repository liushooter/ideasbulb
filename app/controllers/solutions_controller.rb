class SolutionsController < ApplicationController
  authorize_resource

  def create
    @solution = Solution.new(params[:solution])
    @solution.user = current_user
    @idea_id = params[:idea_id] 
    @solution.idea = Idea.find(@idea_id)
    @solution.save
  end

  def update
    @solution = current_user.solutions.find(params[:id])
    @solution.update_attributes(params[:solution])
  end
  
  def destroy
    @solution = current_user.solutions.find(params[:id])
    @solution.destroy
  end

  def pick
    @solution = Solution.find(params[:id])
    @solution.update_attribute("pick",true)
  end

  def unpick
    @solution = Solution.find(params[:id])
    @solution.update_attribute("pick",false)
  end
end
