require File.dirname(__FILE__) + '/../spec_helper'

describe LoginController do
  describe "GET 'show'" do
    context "before authenticated" do
      it "should be successful" do
        get 'show'
        response.should be_success
      end
    end

    context "after authenticated" do
      it "should redirect to the index path" do
        session[:login_user_id] = 1
        get 'show'
        response.should redirect_to('/')
      end
    end
  end

  describe "POST 'authenticate'" do
    context "login success" do
      before(:all) do
        @user = User.where(:name => 'atsumi')[0]
      end

      it "should redirect to the index path" do
        post 'authenticate', :user_name => "atsumi", :user_pass => "atsumi1031"
        response.should redirect_to('/')
      end

      it "should retain user id in the session" do
        post 'authenticate', :user_name => "atsumi", :user_pass => "atsumi1031"
        session[:login_user_id].should == @user.id
      end
    end

    context "login fail" do
      it "should redirect to the login/show" do
        post 'authenticate', :user_name => "atsumi", :user_pass => "atsumi103111"
        response.should redirect_to :action => "show"
      end

      it "should not have user id in the session" do
        post 'authenticate', :user_name => "atsumi", :user_pass => "atsumi103111"
        session[:login_user_id].should == nil
      end
    end
  end
end
