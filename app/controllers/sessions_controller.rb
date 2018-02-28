class SessionsController < ApplicationController

  def login
    #action for the login view
  end

  def signup
    #action for the signup view
  end

  def access_tokens_refresh
    user = User.find_by(refresh_token: params[:refresh_token])
    if user
      exp = (DateTime.now + 10.minutes).to_i
      user.update(token_expires_at: exp)
      user.set_auth_token
      return render json: { 'jwt': user.auth_token }, status: :ok
    else
      return render json: { status: 404, message: 'Not Found', code: 404}
    end
  end

  def create
    user = User.find_by(email: params[:email])
    if user && params[:password]
      if user.password_digest == Digest::SHA1.hexdigest(params[:password])
        exp = (DateTime.now+10.minutes).to_i
        user.update(token_expires_at: exp)
        user.update(refresh_token: Digest::SHA1.hexdigest([Time.now, rand].join))
        user.set_auth_token
        return render json: { jwt: user.auth_token, refresh_token: user.refresh_token }, status: 201
      end
      return render json: { message: 'Forbidden', code: 403}, status: 403
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
      return render json: {}, status: 404
    end
  end
end