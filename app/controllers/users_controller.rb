class UsersController < ApplicationController
  def show # page that shows info about the user
    @user = User.find(params[:id])
  end

  def new # page that allows for creation of a new user!!!
    @title = "Sign up"
  end

end
