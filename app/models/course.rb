class Course < ActiveRecord::Base
  attr_accessible :category, :comments, :description, :duration, :required_for, :status, :term, :title
  has_many :certs
  
  CATEGORY_CHOICES = ['General', 'Police', 'Admin', 'CERT', 'SAR']
  REQUIRED_FOR_CHOICES = ['Police', 'CERT','SAR']

  validates_presence_of :title, :status

end
