require 'digest'
require 'net/http'
require 'uri'

class Entry < ActiveRecord::Base
  attr_accessible :title, :shortcode, :longcode, :comments, :picture
  
  belongs_to :user
  has_many :votes
  belongs_to :contest
  
  has_many :reverse_relationships, :foreign_key => "entry_id",
                                   :class_name => "Vote"
  has_many :voters, :through => :reverse_relationships, :source => :user
  
  validates :title, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true
  validates :shortcode, :presence => true, :length => { :maximum => 256 }
  validates :longcode, :length => { :maximum => 8192 }
  validates :comments, :length => { :maximum => 8192 }
  
  class UniquetitleValidator < ActiveModel::EachValidator
    def validate_each(entry, attribute, value)
      if Entry.all.find_all{|e| e.contest == Contest.current_contest and
                                e.user_id == entry.user_id and
                                e.title == value and
                                e.id != entry.id }.size > 0
        entry.errors[attribute] << "must be unique to your other entries."
        return false
      end
      return true
    end
  end
  
  validates :title, :uniquetitle => true
  
  default_scope :order => 'entries.created_at DESC'
  
  
  def self.pov_server
    "http://pscc.2-complex.com/"
  end
  
  def image_name
    'im' + hash_entry_params + hash_shortcode
  end
  
  def image_url
  	Entry.pov_server + "images/" + image_name + '.png'
  end
  
  def thumbnail_url
  	Entry.pov_server + "thumbnails/" + image_name + '.png'
  end
  
  def shortcode_url
  	Entry.pov_server + "shortcode/" + image_name + '.pov'
  end
  
  def render_request
    res = Net::HTTP.post_form(URI.parse(Entry.pov_server + 'cgi-bin/request.py'),
        {'name'=>image_name,
         'code'=>shortcode,
         'ini'=>contest.ini,
         'thumbnailini'=>contest.thumbnailini,
         'key'=>key})
  end
  
  def render_status
    res = Net::HTTP.post_form(URI.parse(Entry.pov_server + 'cgi-bin/status.py'),
        {'name'=>image_name,
         'key'=>key})
    res.body
  end
  
  def render_status_html
    res = Net::HTTP.post_form(URI.parse(Entry.pov_server + 'cgi-bin/view.py'),
        {'name'=>image_name,
         'key'=>key})
    # a hack to turn relative path names for images into absolute paths
    res.body.gsub( /<\s*img\s+src\s*=\s*"/, '<img src = "' + Entry.pov_server + 'cgi-bin/')
  end
  
  def key
    Digest::SHA2.hexdigest(image_name + String('#bananas23'))
  end
  
  def shortcode_full_hash
    Digest::SHA2.hexdigest(shortcode)
  end
  
  def score
  	r = 0
  	votes.each do |v|
  		r += v.weight
  	end
  	return r
  end
  
  def acquire_contest
    # sets the contest_id field of the entry if it doesn't have it already.
    # this is only because we had entries in our test database before we added contests.
    # we shouldn't need this anymore.
    now = Contest.current_time
	if not contest
	  Contest.all.each do |c|
        if now >= c.startdate and created_at >= c.startdate and created_at < c.entrydeadline
		  contest = c
		  save
		  return c
        end
	  end
	end
  end
  
  def editable?
    now = Contest.current_time
    if contest and now <= contest.entrydeadline
      return true
    end
    return false
  end
  
  def publicly_visible?
    acquire_contest
    now = Contest.current_time
    if contest and now >= contest.votingend
      return true
    end
    return false
  end
  
  def allows_vote_from?(user)
    Contest.current_contest and Contest.current_contest.voting_window? and user and user.may_vote?
  end
  
  private
    def hash_shortcode
      Digest::SHA2.hexdigest(shortcode + String(user_id))[0..5]
    end
    
    def hash_entry_params
      Digest::SHA2.hexdigest(String(user_id) + String(id))[0..5]
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


