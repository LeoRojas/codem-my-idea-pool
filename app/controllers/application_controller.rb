class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception #commented out for postman and cm-quiz tests
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

  def response_401
    return render json: { status: 401, message: 'Unauthorized', code: 401}, status: 401
  end

  def valid_password? (password)
    # VALID_PASSWORD_REGEX = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$"
    password = password.to_s
    valid_password = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$/
    return valid_password.match(password) ? true : false
    # password.present? && (password =~ valid_password)
  end
end