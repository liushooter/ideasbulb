class AddLinkAndDescriptionToTopics < ActiveRecord::Migration
  def change
    add_column :topics,:website,:string
    add_column :topics,:description,:string
  end
end
