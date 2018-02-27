class UsersController < ApplicationController

  def create
    user = User.new(user_params.except(:password))
    # byebug
    if user_params[:password]
      user.encrypt_password(user_params[:password])
      exp = (DateTime.now+10.minutes).to_i
      user.token_expires_at = exp
      jwt_token = JWT.encode({exp: exp, id: user.id, email: user.email, name: user.name}, nil, 'none')
      user.auth_token = jwt_token
      refresh_token = Digest::SHA1.hexdigest([Time.now, rand].join)
      user.refresh_token = refresh_token
    end
    if user.save
      render json: { 'jwt': jwt_token, 'refresh_token': refresh_token }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def me
    token = request.headers["X-Access-Token"]
    user = User.find_by(auth_token: token)
    if user
      decoded_token = JWT.decode token, nil, false
      if decoded_token[0]['exp'] < DateTime.now.to_i
        return render json: { status: 400, message: 'Bad Request', code: 400}
      else
        return render json: { status: 200, email: user.email, name: user.name, avatar_url: user.avatar_url, code: 200}
      end
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
