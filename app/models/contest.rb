class Contest < ActiveRecord::Base
  attr_accessible :title, :rules, :ini, :thumbnailini, :charlimit
  attr_accessible :startdate, :entrydeadline, :votingstart, :votingend
  
  has_many :entries
  has_many :votes
  
  validates :title, :presence => true, :length => { :maximum => 200 }
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

