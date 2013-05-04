# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'search item' do
  it 'should call api without error' do
    res = Amazon::API.search_music('サザン')
    res.is_valid_request?.should be_true
  end
end
