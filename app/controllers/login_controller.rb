class LoginController < ApplicationController
  # show login page
  def show
  end

  # do login authentication
  def authenticate
    user = User.authenticate(params[:user_name], params[:user_pass])
    if user
      session[:login_user_id] = user.id
      redirect_to "/"
    else
      redirect_to :action => "show"
    end
  end
end
