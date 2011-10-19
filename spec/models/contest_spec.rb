require 'spec_helper'

describe Contest do
  pending "add some examples to (or delete) #{__FILE__}"
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

