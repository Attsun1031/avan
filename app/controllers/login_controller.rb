# coding: utf-8

class LoginController < ApplicationController
  skip_filter :check_logined

  def index
    if session[:login_user_id] != nil
      redirect_to '/'
    end
  end

  # ログイン認証を行う
  def authenticate
    user = User.authenticate(params[:user_name], params[:user_pass])
    if user
      session[:login_user_id] = user.id
      redirect_path = params[:referer] ? params[:referer] : '/'
      redirect_to redirect_path
    else
      flash.now[:referer] = params[:referer]
      redirect_to :action => 'index'
    end
  end
end
