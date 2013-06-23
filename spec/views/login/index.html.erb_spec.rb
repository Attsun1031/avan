require 'spec_helper'

describe "/login/index" do
  before(:each) do
    render
  end

  before(:each) do
    flash[:referer] = '/'
  end

  it "should has user_name input tag" do
    assert_select('form#login input[type=text][name="user_name"]')
  end

  it "should has password input tag" do
    assert_select('form#login input[type=password][name="user_pass"]')
  end

  it "should has submit button" do
    assert_select('form#login input[type=submit]')
  end

  it "should has referer hidden tag" do
    assert_select('form#login input[type=hidden][id="referer"]')
  end
end
