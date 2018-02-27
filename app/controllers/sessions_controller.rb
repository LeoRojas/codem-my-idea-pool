class SessionsController < ApplicationController

  def login

  end

  def signup
  end

  def access_tokens_refresh
    user = User.find_by(refresh_token: params[:refresh_token])
    if user
      exp = (DateTime.now+10.minutes).to_i
      user.token_expires_at = exp
      jwt_token = JWT.encode({exp: exp, id: user.id, email: user.email, name: user.name}, nil, 'none')
      user.auth_token = jwt_token
      user.save
      render json: { 'jwt': jwt_token }, status: :ok
    else
      return render json: { status: 404, message: 'Not Found', code: 404}
    end
  end

  def create
    user = User.find_by(email: params[:email])
    # byebug
    if user && params[:password]
      if user.password_digest == Digest::SHA1.hexdigest(params[:password])
        exp = (DateTime.now+10.minutes).to_i
        user.token_expires_at = exp
        jwt_token = JWT.encode({ exp: exp, id: user.id, email: user.email, name: user.name }, nil, 'none')
        user.auth_token = jwt_token
        user.refresh_token = Digest::SHA1.hexdigest([Time.now, rand].join)
        user.save
        return render json: { status: 201, jwt: user.auth_token, refresh_token: user.refresh_token }, status: 201
      end
      return render json: { status: 403, message: 'Forbidden', code: 403}
    end
    return render json: { status: 404, message: 'Not Found', code: 404}
  end

  def destroy
    user = User.find_by(refresh_token: params[:refresh_token])
    if user
      user.auth_token = nil
      user.refresh_token = nil
      user.token_expires_at = nil
      user.save
      return render json: {}, status: 204
    else
      return render json: { status: 404, message: 'Not Found', code: 404}
    end
  end
end