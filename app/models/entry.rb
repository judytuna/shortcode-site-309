class Entry < ActiveRecord::Base
  attr_accessible :title, :shortcode, :longcode, :comments, :picture
  
  belongs_to :user
  has_many :votes
  has_many :voters, :through => :votes, :source => :entry_id
  
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
#  id         :integer         not null, primary key
#  title      :string(255)
#  user_id    :integer
#  shortcode  :text
#  longcode   :text
#  comments   :text
#  created_at :datetime
#  updated_at :datetime
#


# searches for substrings of s with no space or tab of length at least l
# and artificially inserts newlines to break them up.
def wrap(s)
  r = ""
  i = 0
  n = s.length
  sofar = 0
  while i < n
    s[i]
    i+=1
    r << String(s[i])
    
    if /\s/ =~ s[i]
      sofar = 0
    else
      sofar += 1
    end
    
    if sofar >= 100
      r << "\n"
      sofar = 0
    end
  end
  return r
end


