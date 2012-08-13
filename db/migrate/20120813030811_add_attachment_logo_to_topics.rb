class AddAttachmentLogoToTopics < ActiveRecord::Migration
  def self.up
    change_table :topics do |t|
      t.has_attached_file :logo
    end
  end

  def self.down
    drop_attached_file :topics, :logo
  end
end
