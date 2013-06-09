# coding: utf-8

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_logined

  private
  # ログインチェックを行うフィルタ
  # 有効なログインがない場合はログインページにリダイレクトする。
  def require_logined
    # ユーザーをロード
    if session[:login_user_id] != nil
      begin
        @user = User.find(session[:login_user_id])
      rescue ActiveRecord::RecordNotFound
        reset_session
      end
    end

    # ロードできない場合はリダイレクト
    unless @user
      flash[:referer] = request.fullpath
      redirect_to :controller => 'login', 'action' => 'index'
    end
  end

  # ログインしていないことをチェックするフィルタ
  # ログインしている場合はルート URL にリダイレクト
  def require_not_logined
    if session[:login_user_id] != nil
      redirect_to root_url
    end
  end
end
