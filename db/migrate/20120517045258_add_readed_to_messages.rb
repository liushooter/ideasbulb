class AddReadedToMessages < ActiveRecord::Migration
  def change
    add_column :messages,:readed,:boolean,:default => false
  end
end
