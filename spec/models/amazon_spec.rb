# coding: utf-8

require File.dirname(__FILE__) + '/../spec_helper'

describe 'Amazon::API' do
  describe 'search item' do
    it 'should call api without error' do
      res = Amazon::API.search_music_items 'サザン'
      res.is_valid_request?.should be_true
    end
  end

  describe 'lookup items' do
    it 'should call api without error' do
      res = Amazon::API.lookup_items '4309977596'
      res.is_valid_request?.should be_true
      res.items.length.should == 1
    end
    it 'should call api with multi item ids' do
      res = Amazon::API.lookup_items ['4309977596','3552050884']
      res.is_valid_request?.should be_true
      res.items.length.should == 2
    end
  end
end
