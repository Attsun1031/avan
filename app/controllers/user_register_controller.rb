# coding: utf-8

require 'date'


# ユーザー登録コントローラー
class UserRegisterController < ApplicationController
  skip_filter :require_logined

  # 入力画面
  def index
    session[:register_user] = nil
  end

  # 登録内容の確認処理
  # TODO: バリデーション
  def confirm
    date_params = %w(1 2 3).map { |e| params[:birthday]["date(#{e}i)"].to_i }
    logger.info date_params
    birthday = Date.new(*date_params)
    register_params = {
      :name => params[:name],
      :birthday => birthday,
      :sex => params[:sex],
      :password => params[:password]
    }

    session[:register_user] = User.create_new_user register_params
  end

  # 登録処理
  def register
    # セッションチェック
    if session[:register_user].nil?
      flash[:error] = "予期せぬ操作が行われました。申し訳ありませんが操作をやり直してください。"
      redirect_to :action => :index
      return
    end

    session[:register_user].save
    session[:register_user] = nil
  end
end
