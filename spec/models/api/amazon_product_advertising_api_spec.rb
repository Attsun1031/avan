# coding: utf-8

require File.dirname(__FILE__) + '/../../spec_helper'
require 'api/amazon_product_advertising_api'

describe 'ItemSearchAPI' do
  it 'should get some items' do
    items = AmazonProductAdvertisingAPI::API::ItemSearchAPI.search_cd('サザン', ["ItemAttributes"])
    items.length.should == 1
    items[0].item_attributes.artist.should == 'サザンオールスターズ'
  end
end

describe 'ItemSearchAPIRequest' do
  describe 'build_request_url' do
    it 'should parse request' do
      params = {
        :browse_node => 100,
        :keywords => 'King Crimson',
        :reponse_group  => ['ItemAttributes', 'Images']
      }
      request = AmazonProductAdvertisingAPI::Request::ItemSearchAPIRequest.new params
      url = request.build_request_url
      url.should == 'http://ecs.amazonaws.jp/onca/xml?AWSAccessKeyId=AKIAIDM4TLOUUWY5KHFA&AssociateTag=progremeibans-22&BrowseNode=561956&Keywords=kingcrimson&Operation=ItemSearch&ResponseGroup=ItemAttributes&SearchIndex=Music&Service=AWSECommerceService&Timestamp=2012-12-26T12%3A13%3A53Z&Version=2011-08-01&Signature=XA%2F3h0q97f3rS%2FCKo2X5gbzHMqyyNXTIM8XFjXj2i6U%3D'
    end
  end
end
