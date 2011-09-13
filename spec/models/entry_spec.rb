require 'spec_helper'

describe Entry do
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :title => "my beautiful povray thing",
              :shortcode => "something",
              :longcode => "something longer",
              :comments => "a description of my process"}
  end
  
  it "should create a new instance given valid attributes" do
    @user.entries.create!(@attr)
  end
  
  describe "user associations" do
    
    before(:each) do
      @entry = @user.entries.create(@attr)
    end
    
    it "should have a user attribute" do
      @entry.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @entry.user_id.should == @user.id
      @entry.user.should == @user
    end
  end
  
  describe "validations" do
    
    it "should require a user id" do
      Entry.new(@attr).should_not be_valid
    end
    
    it "should require nonblank title" do
      @user.entries.build(:title => "  ").should_not be_valid
    end
    
    it "should require nonblank shortcode" do
      @user.entries.build(:shortcode => "  ").should_not be_valid
    end
    
    it "should reject long shortcode content" do
      @user.entries.build(:shortcode => "a" * 257).should_not be_valid
    end
  end
  
end
