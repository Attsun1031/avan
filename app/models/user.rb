# coding: utf-8

class User < ActiveRecord::Base

  USER_SALT = '_avan1201'

  attr_accessible :birthday, :image_path, :last_login_datetime, :mail_address, :name, :password_digest, :profile, :registered_datetime, :sex, :twitter_id
  validates :name, :presence => { :message => 'ユーザー名を入力してください。' }
  validates :password_digest, :presence => { :message => 'パスワードを入力してください。' }

  def self.authenticate user_name, password
    digest = self.create_digest password
    user = where(:name => user_name, :password_digest => digest)
    if user != nil and user.length > 0
      return user[0]
    else
      return nil
    end
  end

  def self.create_new_user params
    user = self.new
    user.name = params[:name]
    user.birthday = params[:birthday]
    user.sex = params[:sex]
    user.password_digest = self.create_digest params[:password]
    return user
  end

  protected
  def self.create_digest password
    if password.blank?
      return nil
    end
    return Digest::SHA1.hexdigest(password + USER_SALT)
  end
end
