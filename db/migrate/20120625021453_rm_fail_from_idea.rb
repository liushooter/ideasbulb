class RmFailFromIdea < ActiveRecord::Migration
  def change
    remove_column :ideas,:fail
  end
end
