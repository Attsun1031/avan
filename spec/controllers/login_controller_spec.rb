require File.dirname(__FILE__) + '/../spec_helper'

describe LoginController do
  fixtures :users

  describe "GET 'index'" do
    context "before authenticated" do
      it "should be successful" do
        get 'index'
        response.should be_success
      end
    end

    context "after authenticated" do
      it "should redirect to the index path" do
        session[:login_user_id] = 1
        get 'index'
        response.should redirect_to('/')
      end
    end
  end

  describe "POST 'authenticate'" do
    context "login success" do
      before(:all) do
        @user = User.where(:name => 'atsumi')[0]
      end

      before(:each) do
        @params = {:user_name => "atsumi", :user_pass => "atsumi1031", :referer => "/"}
      end

      it "should redirect to the index path" do
        post 'authenticate', @params
        response.should redirect_to('/')
      end

      it "should retain user id in the session" do
        post 'authenticate', @params
        session[:login_user_id].should == @user.id
      end
    end

    context "login fail" do
      it "should redirect to index" do
        post 'authenticate', :user_name => "atsumi", :user_pass => "atsumi103111"
        response.should redirect_to :action => 'index'
      end

      it "should not have user id in the session" do
        post 'authenticate', :user_name => "atsumi", :user_pass => "atsumi103111"
        session[:login_user_id].should == nil
      end
    end
  end
end
