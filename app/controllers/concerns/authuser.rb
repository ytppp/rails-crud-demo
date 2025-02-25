module Authuser
  def current_user
    return @current_user if @current_user

    token = request.headers['Authorization']
    return nil if token.nil?

    info= JsonWebToken.decode(token)
    @current_user = User.find_by_id(info[:user_id])
  end
end
