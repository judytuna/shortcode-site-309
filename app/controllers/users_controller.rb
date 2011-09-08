class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]

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
      sign_in @user
      flash[:success] = "Welcome to the POVRay shortcode contest!"
      redirect_to @user
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end

  def edit
 #   @user = User.find(params[:id]) -- removed when i added the correct_user function
    @title = "Edit user" 
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  

  private
    
    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])  #this gets :id from the current url, right?
      redirect_to(root_path) unless current_user?(@user) #current_user? is in sessions_helper
    end
  
end
