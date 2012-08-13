class Topic < ActiveRecord::Base
  has_many :ideas
  has_attached_file :logo, :styles => { :medium => "120x120#", :small => "50x50#"},:url => "/system/:attachment/:id/:style/:filename",:whiny => false

  validates :name,:presence =>true,:length => {:maximum => 30}
  validates :description,:length => {:maximum => 160}
  validates_format_of :website, :with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,:allow_blank => true
  validates :logo,:attachment_content_type => {:content_type=>["image/jpeg","image/png"],:message => I18n.t('app.error.topic.logo_content_type')},:attachment_size => { :less_than => 50.kilobytes,:message => I18n.t('app.error.topic.logo_file_size') }
  before_destroy :check_product_count

  def check_product_count
    unless self.ideas.count == 0
      errors[:base] << I18n.t('app.error.topic.zero_ideas')
      false
    end
  end

  before_save do |topic|
    topic.website = nil if topic.website && topic.website.strip.empty?
  end

  def status_ideas
    {
      IDEA_STATUS_UNDER_REVIEW => self.ideas.where("status=?",IDEA_STATUS_UNDER_REVIEW).order("ideas.created_at DESC").first,
      IDEA_STATUS_REVIEWED_SUCCESS => self.ideas.where("status=?",IDEA_STATUS_REVIEWED_SUCCESS).order("ideas.created_at DESC").first,
      IDEA_STATUS_LAUNCHED => self.ideas.where("status=?",IDEA_STATUS_LAUNCHED).order("ideas.created_at DESC").first
    }
  end
end
