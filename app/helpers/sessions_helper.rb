module SessionsHelper

  def current_user
    @current_user ||= user_from_remember_token #1st time: calls user_from_remember_token
       #thereafter: just returns @current_user (no call to rmbrtoken). memoization.
  end

  def current_user=(user)
    @current_user = user
  end

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user= user #Because the Sessions helper module is included in the Application controller, the self variable here is the controller itself. 
    #NMgot rid of the "= user" to the right of self.current_user to make tests pass xP
  end
  
  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user= nil #trying to set the current user to nil
    #but our current_user method wants to set it and it doesn't take an arg
    #pxasik, i'm gonna try my own way
    #@current_user = nil #uh, if i call current_user though, will it do user_from_remember_token?!?!?!?!? gahhhhhhhhhhhhhhhhhh
  end 

  def current_user?(user)
    user == current_user
  end
  
  def authenticate
    deny_access unless signed_in?
  end

  def deny_access #for authentication checks before edit/update
    store_location #for friendly forwarding
    redirect_to signin_path, :notice => "Please sign in to access this page."
       #the ":notice" part is passing an options hash to the redirect_to function
  end

  def redirect_back_or(default) #allows you to set a default path when you call this
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil] # if right is nil, return actual nil array
    end

    def store_location 
      session[:return_to] = request.fullpath #puts the requested URL in the 
         # session variable under the key :return_to !!!!!!!
    end
 
    def clear_return_to
      session[:return_to] = nil
    end

end
