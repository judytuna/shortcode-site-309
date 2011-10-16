class Vote < ActiveRecord::Base
  attr_accessible :entry_id, :weight
  
  belongs_to :user, :class_name => "User"
  belongs_to :entry, :class_name => "Entry"
  
  validates :user_id, :presence => true
  validates :entry_id, :presence => true
  
  class SelfvoteValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if Entry.find_by_id(value).user.id == record.user_id
        record.errors[attribute] << "can't be your own"
      end
    end
  end
  
  validates :entry_id, :selfvote => true
  # need a validation: user_id not equal to Entry.find_by_id(entry_id).user.id

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

