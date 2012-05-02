class CreateUsersVoteSolutions < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :solution_id
      t.boolean :like
  
      t.timestamps
    end

    add_index :votes,[:user_id,:solution_id],:unique => true
  end
end
