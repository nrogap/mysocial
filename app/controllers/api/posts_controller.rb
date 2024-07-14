class Api::PostsController < Api::ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.order(created_at: :desc)

    render json: @posts
  end

  def show
    @post = Post.find(params[:id])

    render json: @post
  end

  def create
    @post = Post.new(message: create_params[:message], user_id: current_user.id)

    if @post.save
      render json: @post
    else
      render json: { error: error_message }, status: :unprocessable_entity
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(update_params)
      render json: @post
    else
      render json: { error: error_message }, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])

    @post.destroy

    head :ok
  end

  private

    def error_message
      @post.errors.full_messages.first
    end

    def create_params
      params.require(:post).permit(:message)
    end

    def update_params
      params.require(:post).permit(:message)
    end
end
