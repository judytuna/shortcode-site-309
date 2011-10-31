
class Contest < ActiveRecord::Base
  attr_accessible :title, :rules, :ini, :thumbnailini, :charlimit
  attr_accessible :startdate, :entrydeadline, :votingstart, :votingend
  
  has_many :entries
  has_many :votes
  
  validates :title, :presence => true, :length => { :maximum => 200 }
  
  @@time_warp = 0
  
  def self.time_warp
    @@time_warp
  end
  
  def self.time_warp=(n)
    @@time_warp = n
  end
  
  def self.current_time
    Time.now.utc + @@time_warp
  end
  
  # IT'S A CLASS METHOD!!!!!!!! Call it by going Contest.current_contest
  def self.current_contest
    now = current_time
    
    # look through all contests
    all.each do |contest| 
      if now >= contest.startdate && now <= contest.votingend
        return contest
      end
    end
    # return nil if there is currently no contest running
    return nil
  end
  
  def self.next_contest
    now = current_time
    
    n = all.max_by {|c| c.startdate}
    if n and n.startingdate > now
    	return n
    end
    
    return nil
end
  
end

Contest.time_warp = 0


# == Schema Information
#
# Table name: contests
#
#  id            :integer         not null, primary key
#  title         :string(255)
#  charlimit     :integer
#  startdate     :datetime
#  entrydeadline :datetime
#  votingstart   :datetime
#  votingend     :datetime
#  rules         :text
#  ini           :text
#  thumbnailini  :text
#  created_at    :datetime
#  updated_at    :datetime
#

