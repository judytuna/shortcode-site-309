class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      #sign the user in and redirect to the user's show page
      sign_in user
      redirect_to user
    end #of the if
  end

  def destroy
  end

end
