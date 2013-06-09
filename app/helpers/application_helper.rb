# coding: utf-8

module ApplicationHelper

  # ログイン情報エリアを構築する
  def login_info
    if session[:login_user_id] != nil
      link_to "ログアウト", "/login/destroy"
    elsif
      link_to "ログイン", "/login"
    end
  end
end
