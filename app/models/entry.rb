class Entry < ActiveRecord::Base
  attr_accessible :title, :shortcode, :longcode, :comments
  belongs_to :user
end
