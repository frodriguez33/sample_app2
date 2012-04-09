module SessionsHelper
  def sign_in(user)

    cookies.permanent.signed[:login_time] = Time.now.to_s
    self.current_user = user

    if params[:session][:remember] == "0"
       cookies.signed[:remember_token] = [user.id, user.salt]      
    else
      cookies.permanent.signed[:remember_token] = [user.id, user.salt]      
    end

    
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

end
