module SessionsHelper

  def current_user
    @current_user ||= user_from_remember_token #1st time: calls user_from_remember_token
          #2nd time: just returns @current_user (no call rmbrtoken). memoization.
  end


  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user  #Because the Sessions helper module is included in the Application controller, the self variable here is the controller itself.
  end
 
 
  def signed_in?
    !current_user.nil?
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil] # if right is nil, return actual nil array
    end

end
