class Contest < ActiveRecord::Base
  attr_accessible :title, :rules, :ini, :thumbnailini, :charlimit
  attr_accessible :startdate, :entrydeadline, :votingstart, :votingend
  
  has_many :entries
  has_many :votes
  
  validates :title, :presence => true, :length => { :maximum => 200 }
  
  # IT'S A CLASS METHOD!!!!!!!! Call it by going Contest.current_contest... we think
  def self.current_contest
    now = Time.now.utc
    
    # look through all contests
    all.each do |contest| 
      if now >= contest.startdate && now <= contest.votingend
        return contest
      end
    end
    # return nil if there is currently no contest running
    return nil
  end
  
end

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

