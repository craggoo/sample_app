class UsersController < ApplicationController
  def show
  	@User = User.find(params[:id])
  end
  def new
  	@User = User.new
  end
  def create
  	@User = User.new(user_params)
  	if @User.save
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @User
  	else
  		render 'new'
  	end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end
end

