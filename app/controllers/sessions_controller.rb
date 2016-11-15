class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      login @user
      redirect_to @user
    else
      flash.now[:danger] = "Invalid username/password combination"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private
  	def session_params
  		params.require(:session).permit(:email, :password, :password_confirmation)
  	end
end
