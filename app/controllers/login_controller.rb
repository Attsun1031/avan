# coding: utf-8

# ログインセッション管理
class LoginController < ApplicationController
  before_filter :require_not_logined, :except => "destroy"
  skip_filter :require_logined, :except => "destroy"

  # ログイン認証を行う
  def authenticate
    user = User.authenticate(params[:user_name], params[:user_pass])
    if user
      session[:login_user_id] = user.id
      redirect_path = params[:referer] ? params[:referer] : '/'
      redirect_to redirect_path
    else
      flash.now[:referer] = params[:referer]
      flash[:error] = 'ユーザー名とパスワードが一致しません。'
      redirect_to :action => 'index'
    end
  end

  # ログインセッションを破棄する
  def destroy
    reset_session
    redirect_to :action => 'index'
  end
end
