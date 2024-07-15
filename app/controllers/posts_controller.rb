class PostsController < ApplicationController
  before_action :raise_not_sign_in_error, except: [:index, :show]

  def index
    @posts = Post.order(created_at: :desc).offset(0).limit(5)
  end

  def index_by_user
    @posts = Post.where(user_id: params[:user_id]).order(created_at: :desc).offset(0).limit(5)
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    if !sign_in?
      # # TODO: redirect_to user_registeration page
    end

    @post = Post.new
  end

  def create
    raise_not_sign_in_error

    @post = Post.new(message: post_params[:message], user_id: current_user.id)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

    def post_params
      params.require(:post).permit(:message)
    end

    def raise_not_sign_in_error
      raise "You need to sign in or sign up before continuing." if !current_user.present?
    end

    def sign_in?
      current_user.present?
    end
end
