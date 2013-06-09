class User < ActiveRecord::Base

  USER_SALT = '_avan1201'

  attr_accessible :birthday, :image_path, :last_login_datetime, :mail_address, :name, :password_digest, :profile, :registered_datetime, :sex, :twitter_id
  validates_presence_of :name

  def self.authenticate user_name, password
    digest = self.create_digest password
    user = where(:name => user_name, :password_digest => digest)
    if user != nil and user.length > 0
      return user[0]
    else
      return nil
    end
  end

  def set_password password
    @password_digest = self.class.create_digest password
  end

  protected
  def self.create_digest password
    return Digest::SHA1.hexdigest(password + USER_SALT)
  end
end
