require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do # aka new session, aka get sign in data from user

    it "should be successful" do
      get 'new'
      response.should be_success
    end
    it "should have the right title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end #of GET 'new'

  describe "POST 'create'" do # aka actually make the new session
 
    describe "invalid signin" do

      before(:each) do
        @attr = { :email => "email@example.com", :password => "invalid" }
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "should have the right title" do
        post :create, :session => @attr
        response.should have_selector("title", :content => "Sign in")
      end

      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
    end #of invalid signin

    describe "valid signin" do
      before(:each) do
        @user = Factory(:user)
        @attr = { :email => @user.email, :password => @user.password }
      end

      it "should sign the user in" do
        post :create, :session => @attr
        # fill in w/ tests for a signed-in user.
        controller.current_user.should == @user  # aka controller.signed_in?.should be_true and we'll defined a signed_in? method soon. also signed_in? is attached to the controller, not to a user
        controller.should be_signed_in
      end

      it "should render the right page aka redirect to the user show page" do
        post :create, :session => @attr
        response.should redirect_to(user_path(@user))
      end
 
#      it "should have the right title" do
 #       post :create, :session => @attr
  #      response.should have_selector("title", :content => "#{@attr.name}")
   #   end

  #    it "should have a flash.now message"
    end #valid signin
  end #of POST 'create'    

end
