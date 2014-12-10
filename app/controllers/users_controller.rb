class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @articles = @user.articles[-5..-1]
    # Don't push commented out code to master.
    # @votes = Vote.find_by(voter_id: @user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to(articles_path)
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:handle, :email, :password, :password_confirmation, :about)
  end
end
