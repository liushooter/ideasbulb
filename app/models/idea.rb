class Idea < ActiveRecord::Base
  has_and_belongs_to_many :tags
  belongs_to :user
  belongs_to :topic
  has_many :favorers,:through => :favors,:source =>:user
  has_many :favors
  has_many :comments,:order => "created_at"
  has_many :solutions,:order => "points desc"

  self.per_page = 30

  attr_accessor :is_handle
  attr_accessor :tmp_tag_ids

  validates :title,:presence =>true,:length => {:maximum => 60}
  validates :description,:presence =>true,:length => {:maximum => 2000}
  validate :tags_number_not_greater_than_three

  after_create do |idea|
    User.update_points(idea.user_id,USER_NEW_IDEA_POINTS)
  end
  
  after_save do |idea|
    Tag.update_count(self.tmp_tag_ids) if !is_handle
  end

  before_update do |idea|
    if !is_handle && idea.status == IDEA_STATUS_LAUNCHED
      errors.add(:status,I18n.t('app.error.idea.edit'))
      return false
    end
  end 

  searchable do
   text :title,:description
  end

  def tag_names=(names)
    self.tmp_tag_ids = self.tags.collect{|tag| tag.id}
    self.tags = Tag.with_names(names.split(/\s+/))
    self.tags.each do |tag|
      self.tmp_tag_ids << tag.id unless self.tmp_tag_ids.include?(tag.id)
    end
  end

  def tag_names
    tags.map(&:name).join(' ')
  end

  def tags_number_not_greater_than_three
    if self.tags.length > 3
      errors.add(:tags,I18n.t('app.error.idea.tags_number'))
    end
  end

  def self.update_solutions_points(idea_id)
    connection.update("UPDATE `ideas` SET `solutions_points` = (SELECT SUM(`points`) FROM `solutions` WHERE `idea_id` = #{idea_id}) WHERE `id` = #{idea_id}")
  end
end
