class Contest < ActiveRecord::Base
  has_many :entries
  has_many :votes
end
