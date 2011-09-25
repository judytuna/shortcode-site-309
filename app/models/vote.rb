class Vote < ActiveRecord::Base
  attr_accessible :entry_id
  
  belongs_to :user, :class_name => "User"
  belongs_to :entry, :class_name => "Entry"
  
  validates :user_id, :presence => true
  validates :entry_id, :presence => true
end
