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

    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end

    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end

    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end

    it "should have a password confirmation field" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]']
                                          [type='password']") 
    end
   
    #exercise 10.6.3 - new 
    describe "logged-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should redirect 'new' to root" do
        get :new
        response.should redirect_to(root_path)
      end

    end #of describe "logged-in user" in new


  end # of get new

  
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

    describe "success" do
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar" }
      end

      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end

      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~  /welcome to the povray/i # =! compares strings to regular expressions and /i forces a case-insensitive match
      end

      it "should sign the user in" do
        post :create, :user => @attr
        controller.should be_signed_in
      end

    end #of describe "success"

    #exercise 10.6.3 - create ????
    describe "logged-in user" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end

      it "should redirect :create to root" do
        post :create, :user => @atter
        response.should redirect_to(root_path)
      end

    end #of describe "logged-in user" in new

  end #of describe POST 'create'



  describe "GET 'edit'" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end

    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector("title", :content => "Edit user")
    end

    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      gravatar_url = "http://gravatar.com/emails"
      response.should have_selector("a", :href => gravatar_url,
                                         :content => "change")
    end

  end #of describe "GET 'edit'"


  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end #of "failure" in "PUT 'update'"

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz" }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end #of success (in PUT update)

  end #of describe "PUT 'update'" do


  describe "authentication of edit/update pages" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do

      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end # of "for non-signed in users"

    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
      
    end #of "for signed-in users"

  end # of authentication of edit/update pages


  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "another@example.com")
        third  = Factory(:user, :name => "Ben", :email => "another@example.net")

        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All Users")
      end

      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end

      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination") #check for div tag with class pagination
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end

      it "should not show Delete links" do 
        get :index
        response.should_not have_selector("a", :href => "/users/2", :content => "delete")
      end

    end #for signed in users

    describe "for signed-in admin users" do
      before(:each) do
        @user = test_sign_in(Factory(:user))
        second = Factory(:user, :name => "Bob", :email => "another@example.com")
        @user.toggle!(:admin)
      end

      it "should show Delete links" do 
        get :index
        response.should have_selector("a", :href => "/users/2",
                                           :content => "delete")
      end
    end #for admin users
  end # of "GET 'index'"

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end

    end

    describe "as an admin user" do

      before(:each) do
        admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(admin)
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end

      it "should not let the admin user destroy itself" # do
   #     delete :destroy, :id => admin
    #    flash[:success].should =~ /can't destroy yourself/
     # end

    end
  end #of describe DELETE 'destroy'


end
