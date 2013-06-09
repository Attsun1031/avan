# coding: utf-8

# ユーザー登録コントローラー
class UserRegisterController < ApplicationController
  skip_filter :require_logined

  # TODO: 確認画面に飛ばす
  # TODO: パスワードのバリデーション
  # 登録処理
  def register
    user = User.new
    user.name = params[:name]
    birthday = params[:birthday]
    date_params = %w(1 2 3).map { |e| birthday["date(#{e}i)"].to_i }
    user.birthday = Date.new(*date_params)
    user.sex = params[:sex]
    user.set_password params[:password]
    user.registered_datetime = Time.now
  end
end
