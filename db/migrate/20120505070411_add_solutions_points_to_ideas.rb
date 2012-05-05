class AddSolutionsPointsToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas,:solutions_points,:integer,:default => 0
  end
end
