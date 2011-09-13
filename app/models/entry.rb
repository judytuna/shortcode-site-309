class Entry < ActiveRecord::Base
  attr_accessible :title, :shortcode, :longcode, :comments
  belongs_to :user
  validates :title, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates :shortcode, :presence => true, :length => { :maximum => 256 }
  default_scope :order => 'entries.created_at DESC'
end
