class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception #commented out for postman tests
  require 'jwt'

  def authorize? token
    user = User.find_by(auth_token: token)
    if user
      decoded_token = JWT.decode token, nil, false
      if decoded_token[0]['exp'] < DateTime.now.to_i
       return false
      else
        return true
      end
    else
      return false
    end
  end
end