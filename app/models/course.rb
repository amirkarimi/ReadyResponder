class Course < ActiveRecord::Base
  attr_accessible :category, :comments, :description, :duration, :required_for_pd, :required_for_cert, :required_for_sar, :status, :term, :title, :skill_ids
  has_many :certs
  has_many :people, :through => :certs
  has_and_belongs_to_many :skills
  
  CATEGORY_CHOICES = ['General', 'Police', 'Admin', 'CERT', 'SAR']
  REQUIRED_FOR_CHOICES = ['Police', 'CERT','SAR']

  validates_presence_of :title, :status
  scope :active,  :conditions => {:status => "Active"}
end
