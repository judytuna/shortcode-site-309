require 'spec_helper'

describe UsersController do
  render_views #otherwise, the test won’t pass even after we add the proper title.

  describe "GET 'show'" do
    before (:each) do 
      @user = Factory(:user) #@user simulates an instance of User. defined in spec/factories.rb
    end

    it "should be successful" do
      get :show, :id => @user  #get 'show' is same. & Rails automatically converts the user object to the corresponding id
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user
   # assigns takes in a symbol argument and returns the value of the corresponding instance variable in the controller action. it is a facility provided by RSpec (via the underlying Test::Unit library). 
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name) #title has user's name
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name) #h1 has user's name
    end
  
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector("h1>img", :class => "gravatar") #gravatar in h1
    end

  end #of "Get 'show'" do



  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    it "should have the right title" do
      get 'new'
      response.should have_selector("title", :content => "Sign up") 
 #have_selector needs the render_views line since it tests the view along with the action.
    end
  end

  
  describe "POST 'create'" do #test the /signup form
  
    describe "failure" do
      before(:each) do
        @attr = { :name => "", :email => "", :password => "", :password_confirmation => ""}
    end

      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector("title", :content => "Sign up")
      end

      it "should render the 'new' page again" do
        post :create, :user => @attr
        response.should render_template('new')
      end
    end #of describe "failure" do

  end #of describe POST 'create'


end
