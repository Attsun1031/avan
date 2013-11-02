# coding: utf-8

# TODO: 入力値バリデーションを Itemsearchform のようにしたい。

require 'date'


# ユーザー登録コントローラー
class UserRegisterController < ApplicationController
  skip_filter :require_logined

  # 登録内容の確認処理
  def confirm
    date_params = %w(1 2 3).map { |e| params[:birthday]["date(#{e}i)"].to_i }
    birthday = Date.new(*date_params)

    register_params = {
      :name => params[:name],
      :birthday => birthday,
      :sex => params[:sex],
      :password => params[:password]
    }

    # バリデーション
    input_password = InputPassword.new params[:password], params[:password_for_check]
    register_user = User.create_new_user register_params
    if validate_input register_user, input_password
      session[:register_user] = register_user
    end

  end

  # 登録処理
  def register
    # セッションチェック
    if session[:register_user].nil?
      flash[:error] = "予期せぬ操作が行われました。申し訳ありませんが操作をやり直してください。"
      redirect_to :action => :index
      return
    end

    # 念のためもう一度バリデーション
    if validate_input session[:register_user]
      session[:register_user].register
    end
    session[:register_user] = nil
  end

  private
  # 入力値のバリデーションを行う。
  # 一つでもバリデーションエラーがあれば、エラー文言等の設定を行い終了する。
  def validate_input *inputs
    inputs.each do |each_input|
      unless each_input.valid?
        handle_validation_error each_input.errors
        return false
      end
    end
    return true
  end

  # バリデーションエラー時の設定を行う。
  def handle_validation_error errors
    flash[:error] = errors.messages.values.collect { |e| e[0] }
    redirect_to :action => 'index'
  end
end


# 入力パスワードを扱うクラス
class InputPassword
  attr_reader :errors

  def initialize password, password_for_check
    @password = password
    @password_for_check = password_for_check
    @errors = ActiveModel::Errors.new self
  end

  # パスワードの妥当性を確認する。
  # 妥当でない場合は errors に値が設定される。
  # errors の取り扱いは ActiveModel::Errors と同様。
  def valid?
    @errors.clear
    if @password == @password_for_check
      return true
    else
      @errors[:password_for_check] = "パスワードが一致しません。"
      return false
    end
  end
end
