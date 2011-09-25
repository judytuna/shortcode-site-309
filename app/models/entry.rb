class Entry < ActiveRecord::Base
  attr_accessible :title, :shortcode, :longcode, :comments
  
  belongs_to :user
  has_many :voters, :through => :votes, :source => :entry
  
  validates :title, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates :shortcode, :presence => true, :length => { :maximum => 256 }
  validates :longcode, :length => { :maximum => 8192 }
  validates :comments, :length => { :maximum => 8192 }
  
  default_scope :order => 'entries.created_at DESC'
end

# == Schema Information
#
# Table name: entries
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  user_id    :integer
#  shortcode  :text
#  longcode   :text
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#

