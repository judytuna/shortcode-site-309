require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" , 
              :password => "foobar", :password_confirmation => "foobar"}
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 101
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end

   it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    #put a user with given email address into the database.
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  #package the password validations together  
  describe "password validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end

    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
      
  end #end the package of password validation tests

  #tests about password encryption
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end

    describe "has_password? method" do
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end
    end #end of describe "has password? method"

    describe "authenticate method" do
      
      it "should return nil on email/password mismatch" do
        wrong_pw_usr = User.authenticate(@attr[:email], "wrong password")
        wrong_pw_usr.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_usr = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_usr.should be_nil
      end
   
      it "should return the user on email/password match" do
        matching_usr = User.authenticate(@attr[:email], @attr[:password])
        matching_usr.should == @user
      end
    end #of "authenticate method" 

  end #of password encryption

  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end


  # entry associations - listing 11.5
  describe "entry associations" do
    
    before(:each) do
      @user = User.create(@attr)
      @en1 = Factory(:entry, :user => @user, :created_at => 1.day.ago)
      @en2 = Factory(:entry, :user => @user, :created_at => 1.hour.ago)
    end
  
    it "should have an entries attribute" do
      @user.should respond_to(:entries)
    end
    
    it "should have the right entries in the right order" do
      @user.entries.should == [@en2, @en1] # also checks it's an array
    end
    
    it "should destroy associated entries" do
      @user.destroy
      [@en1, @en2].each do |entry|
        Entry.find_by_id(entry.id).should be_nil
        # or... since Entry.find raises an exception on failure,
        # the following is equivalent:
        # lambda do
        #   Entry.find(entry.id)
        # end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
    
    describe "entries feed for a single user" do
      
      it "should have a feed" do
        @user.should respond_to(:feed)
      end
      
      it "should include the user's entries" do
        @user.feed.include?(@en1).should be_true
        @user.feed.include?(@en2).should be_true
      end
      
      it "should not include a different user's entries" do
        en3 = Factory(:entry,
                      :user => Factory(:user, :email => Factory.next(:email)))
        @user.feed.include?(en3).should be_false
      end
    end
  end
  
  describe "votes" do
    before(:each) do
      @user = User.create!(@attr)
      @voted = Factory(:user)
    end
    
    it "should have a votes method" do
      @user.should respond_to(:votes)
    end
  end

end #of describe User


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

