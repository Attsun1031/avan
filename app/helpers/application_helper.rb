# coding: utf-8

module ApplicationHelper

  # ログイン情報エリアを構築する
  def login_info
    text = "ログイン／新規登録"
    path = "/login"
    if session[:login_user_id] != nil
      text = "ログアウト"
      path ="/login/destroy"
    end
    link_to text, path
  end

  def format_errors errors
    errors.join "\n"
  end
end
