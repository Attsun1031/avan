require File.dirname(__FILE__) + '/../spec_helper'

describe RackController do
  fixtures :users

  describe "GET 'index'" do
    before(:all) do
      @user = User.where(:name => 'atsumi')[0]
    end

    it "should be successful" do
      session[:login_user_id] = @user.id
      get 'index'
      response.should be_success
    end
  end
end
