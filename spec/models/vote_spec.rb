require 'spec_helper'

describe Vote do
  
  before(:each) do
    @voter = Factory(:user)
    @voted = Factory(:entry)
    
    @vote = @voted.votes.build(:voted_id => @voted.id)
  end
  
  it "should create a new instance given valid attributes" do
    @relationship.save!
  end
  
  pending "should have weights and stuff"
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
#

