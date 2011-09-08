require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    
    describe "failure" do
    
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => ""
          fill_in "Email",        :with => ""
          fill_in "Password",     :with => ""
          fill_in "Confirmation", :with => ""
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(User, :count)
      end
    end #of describe failure

    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",         :with => "Example User"
          fill_in "Email",        :with => "user@example.com"
          fill_in "Password",     :with => "foobar"
          fill_in "Confirmation", :with => "foobar"
          click_button
          response.should have_selector("div.flash.success",
                                        :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end 
    end #of describe success

  end #of describe signup


  describe "sign in/out" do

    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in :email, :with => ""
        fill_in :password, :with => ""
        click_button
        # exercise 9.6.1... skipped cuz failure
        response.should have_selector("div.flash.error", :content => "Invalid")
      end
    end #of failure

    describe "success" do
      it "should sign a user in and out" do
        user = Factory(:user)
        #visit signin_path
        #fill_in :email,    :with => user.email
        #fill_in :password, :with => user.password
        #click_button
        integration_sign_in(user)
        
        controller.should be_signed_in
        click_link "Sign out"
        controller.should_not be_signed_in
      end
    end #of success

  end #of describe sign in/out
end

