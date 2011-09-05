class UsersController < ApplicationController
  def show # page that shows info about the user
    @user = User.find(params[:id])
    @title = @user.name  #in rails3, all embedded ruby text is escaped so < -> &lt;
  end

  def new # page that allows for creation of a new user!!!
    @title = "Sign up"
  end

end
