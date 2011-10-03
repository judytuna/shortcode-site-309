class Entry < ActiveRecord::Base
  attr_accessible :title, :shortcode, :longcode, :comments, :picture
  
  belongs_to :user
  has_many :votes
  # has_many :voters, :through => :votes, :source => :entry_id
  
  has_many :reverse_relationships, :foreign_key => "entry_id",
                                   :class_name => "Vote"
  has_many :voters, :through => :reverse_relationships, :source => :user
  
  validates :title, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates :shortcode, :presence => true, :length => { :maximum => 256 }
  validates :longcode, :length => { :maximum => 8192 }
  validates :comments, :length => { :maximum => 8192 }
  
  default_scope :order => 'entries.created_at DESC'
  
  has_attached_file :picture, :styles => { :medium => "300x300>",
                                           :thumb => "100x100>" }
  def image_name
    'im' + String(user_id) + '_' + String(id)
  end
  
  def povserver
    "http://ec2-107-20-100-184.compute-1.amazonaws.com/"
  end
end


# == Schema Information
#
# Table name: entries
#
#  id                   :integer         not null, primary key
#  title                :string(255)
#  user_id              :integer
#  shortcode            :text
#  longcode             :text
#  comments             :text
#  created_at           :datetime
#  updated_at           :datetime
#  picture_file_name    :string(255)
#  picture_content_type :string(255)
#  picture_file_size    :integer
#  picture_updated_at   :datetime
#

