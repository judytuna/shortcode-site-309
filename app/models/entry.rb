class Entry < ActiveRecord::Base
  attr_accessible :title, :shortcode, :longcode, :comments
  belongs_to :user
  default_scope :order => 'entries.created_at DESC'
end
