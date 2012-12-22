require File.dirname(__FILE__) + '/../spec_helper'

describe "User.valid?" do
  before(:each) do
    @user = User.new
  end

  it "should not be valid" do
    @user.should_not be_valid
  end
end

describe "User.authenticate" do
  fixtures :users

  it "should be atuhenticated" do
    User.authenticate('atsumi', 'atsumi1031').name.should == 'atsumi'
  end

  it "should not be atuhenticated" do
    User.authenticate('atsumi', 'atsumi1032').should == nil
    User.authenticate('atsumii', 'atsumi1031').should == nil
    User.authenticate('', 'atsumi1031').should == nil
    User.authenticate('atsumi', '').should == nil
    User.authenticate('', '').should == nil
  end
end
