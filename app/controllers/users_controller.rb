class UsersController < ApplicationController
  def show # page that shows info about the user
    @user = User.find(params[:id])
    @title = @user.name  #in rails3, all embedded ruby text is escaped so < -> &lt;
  end

  def new # page that allows for creation of a new user!!!
    @user = User.new
    @title = "Sign up"
  end

  def create #method for saving new user to db
    @user = User.new(params[:user])
    if @user.save
      #handle a successful save.
      flash[:success] = "Welcome to the POVRay shortcode contest!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

end
