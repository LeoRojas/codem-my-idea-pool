class UsersController < ApplicationController

  def create
    # byebug
    user = User.new(user_params.except(:password))
    # byebug
    # byebug
    # if user_params[:password] # with this line the CM-QUIZ should work, but
    # there is no password parameter inside the user object, its like this
    # <ActionController::Parameters {"email"=>"codementor-test-655c61a07e@codementor.io", "name"=>"codementor-test-655c61a07e", "password"=>"pAssw0rd!", "controller"=>"users", "action"=>"create", "user"=><ActionController::Parameters {"email"=>"codementor-test-655c61a07e@codementor.io", "name"=>"codementor-test-655c61a07e"} permitted: false>} permitted: false>
    # The password param is outside user, and Rails strong params dont allow that, if it comes from a form it should be user[password], I tested it in Postman like that and it works
    if params[:password]
      #byebug
      # user.encrypt_password(user_params[:password]) # Should be this line
      user.encrypt_password(params[:password])
      exp = (DateTime.now+10.minutes).to_i
      user.token_expires_at = exp
      # jwt_token = JWT.encode({exp: exp, id: user.id, email: user.email, name: user.name}, nil, 'none')
      # user.auth_token = jwt_token
      refresh_token = Digest::SHA1.hexdigest([Time.now, rand].join)
      user.refresh_token = refresh_token
    end
    if user.save
      render json: { 'jwt': user.auth_token, 'refresh_token': refresh_token }, status: :created
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
