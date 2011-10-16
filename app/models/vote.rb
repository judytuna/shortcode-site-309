class Vote < ActiveRecord::Base
  attr_accessible :entry_id, :weight
  
  belongs_to :user
  belongs_to :entry
  belongs_to :contest
  
  validates :user_id, :presence => true
  validates :entry_id, :presence => true
end


# == Schema Information
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  entry_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  weight     :integer
#

