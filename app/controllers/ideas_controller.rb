class IdeasController < ApplicationController

  def index
    if authorize? request.headers["X-Access-Token"]
      page = params[:page] ? params[:page] : 1
      @ideas = Idea.order(:average_score).page(page)
      return render json: @ideas
    else
      return render json: { status: 401, message: 'Unauthorized', code: 401}, status: 401
    end
  end

  def create
    if authorize? request.headers["X-Access-Token"]
      idea = Idea.new(idea_params)
      user = User.find_by(auth_token: request.headers["X-Access-Token"])
      idea.user_id = user.id
      if idea.save
        return render json: idea, status: 201
      else
        return render json: {}, status: 422
      end
    else
      return render json: { status: 401, message: 'Unauthorized', code: 401}, status: 401
    end
  end

  def update
    if authorize? request.headers["X-Access-Token"]
      idea = Idea.find(params[:id])
      if idea
        idea.update(idea_params)
        return render json: idea, status: :ok
      else
        return render json: { status: 404, message: 'Not Found', code: 404}
      end
    else
      return render json: { status: 401, message: 'Unauthorized', code: 401}, status: 401
    end
  end

  def destroy
    if authorize? request.headers["X-Access-Token"]
      idea = Idea.find(params[:id])
      idea.destroy
      # None of this worked to reduce the body.size of the response
      # idea.destroy; nil
      # res = render json: {}, status: 204
      # response.body = nil
      # render :nothing => true, status: 204
      # return render :nothing => true, :status => 204
      return render json: {}, status: 204
    else
      return render json: { status: 401, message: 'Unauthorized', code: 401}, status: 401
    end
  end
private
  def idea_params
    params.require(:idea).permit(:content, :impact, :ease, :confidence)
  end
end