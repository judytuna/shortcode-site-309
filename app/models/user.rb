require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password # need this, forget why though 

  #can be modified by outside users (such as users submitting requests with web browsers). 
  attr_accessible :name, :email, :password, :password_confirmation

  has_many :entries, :dependent => :destroy
  has_many :votes
  has_many :voting_for, :through => :votes, :source => :entry
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true, :length => { :maximum => 100 }
  validates :email, :presence => true, 
            :format => { :with => email_regex }, 
            :uniqueness => { :case_sensitive => false } #Rails infers that :uniqueness should be true

  # Automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password #callback

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(email, submitted_password)
    user = find_by_email(email)
    return nil if user.nil?
    return user if user.has_password?(submitted_password)
    # handles the third case (password mismatch) implicitly, since in that case we reach the end of the method, which automatically returns nil. 
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end
  
  def feed
    Entry.where("user_id = ?", id)
  end
  
  def votedfor?(entry)
    votes.find_by_entry_id(entry)
  end
  
  def cast_vote!(entry, weight)
  	puts "****weight = " + weight.to_s
    votes.create!(:entry_id => entry.id, :weight => weight)
  end
  
  def unvote!(entry)
    votes.find_by_entry_id(entry).destroy
  end
  

  private

    def encrypt_password
      self.salt = make_salt if new_record?  #the self makes it refer to the attribute "salt" of the User object that we're currently looking at; if we ommitted "self" then it would make a new local variable called "salt" which is NOT WHAT WE WANT!!!
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string + "hrh")
    end

end


# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

