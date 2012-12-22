require 'spec_helper'

describe "/login/show" do
  before(:each) do
    render
  end

  it "should has h1 tag" do
    assert_select('h1')
  end

  it "should has user_name input tag" do
    assert_select('form#login input[type=text][name="user_name"]')
  end

  it "should has password input tag" do
    assert_select('form#login input[type=password][name="user_pass"]')
  end

  it "should has submit button" do
    assert_select('form#login input#login[type=submit][name="login"]')
  end
end
