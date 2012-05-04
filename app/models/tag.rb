class Tag < ActiveRecord::Base
  has_and_belongs_to_many :ideas

  def self.with_names(names)
    names.map do |name|
      Tag.find_or_create_by_name(name)
    end
  end

  def self.update_count(tags_id)
    connection.update("UPDATE `tags` SET `ideas_count`=
    (SELECT count(*) FROM `ideas_tags` WHERE `tag_id` = `id`) 
    WHERE `id` in (#{tags_id.join(',')})")
  end

end
