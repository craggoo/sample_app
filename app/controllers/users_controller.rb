class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def destroy
    @User.destroy
    flash[:success] = "User deleted."
    redirect_to users_url
  end



  def show
  	@User = User.find(params[:id])
    @microposts = @User.microposts.paginate(page: params[:page])
  end
  
  def new
  	@User = User.new
  end

  def edit
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
  	@User = User.new(user_params)
  	if @User.save
      sign_in @User
  		flash[:success] = "Welcome to the Sample App!"
  		redirect_to @User
  	else
  		render 'new'
  	end
  end

  def update
    if @User.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      redirect_to @User
    else
      render 'edit'
    end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    def correct_user
      @User = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@User)
    end

    def admin_user
      @User = User.find(params[:id])
      redirect_to(root_url) unless current_user.admin?
    end
  end

