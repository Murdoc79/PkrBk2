class SessionsController < ApplicationController
before_action :set_user, only: [:create]
before_action :require_login, only: [:destroy]

  def new
  end

  def create
    if @user
      redirect_back_or_to :controller => 'admin', :notice => "Logged in!"
    else
      flash.now.alert = "Email or password was invalid"
      #redirect_to root_path, :notice => "Logged out!"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, :notice => "Logged out!"
  end

  private
  
  def set_user
    @user = login(params[:username], params[:password], params[:remember_me])
  end

  def session_params
    params.require(:username, :password).permit(:remember_me)
  end

end