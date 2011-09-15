require 'spec_helper'

describe EntriesController do
  render_views
  
  describe "access control" do
    
    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end

  describe "POST 'create'" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :title => "" }
      end
      
      it "should not create an entry" do
        lambda do
          post :create, :entry => @attr
        end.should_not change(Entry, :count)
      end
      
      it "should render the new entry page" do
        post :create, :entry => @attr
        response.should render_template(newentry_path)
      end
      
    end
    
    describe "success" do
      before(:each) do
        @attr = { :title => "Lorem ipsum", :shortcode => "some shortcode",
                  :longcode => "longcode goes here", :comments => "lol"}
      end
      
      it "should create a micropost" do
        lambda do
          post :create, :entry => @attr
        end.should change(Entry, :count).by(1)
      end
      
      it "Should redirect to the user show page" do
        post :create, :entry => @attr
        response.should redirect_to(@user)
      end
      
      it "should have a flash message" do
        post :create, :entry => @attr
        flash[:success].should =~ /entry created/i
      end
    end
    
  end
end
