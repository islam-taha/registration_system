module ActAsAuthorizable
  def sign_in(user)
    session[:user_id]             = user.id
    cookies.permanent[:signed_in] = true
  end

  def sign_out
    session[:user_id] = nil
  end
end
